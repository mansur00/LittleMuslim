const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const FIXTURES = path.join(ROOT, 'tools', '__fixtures__');

// Regex patterns matching tools/i18n_check.js
const REGEX_BENGALI = /[\u0980-\u09FF]/;
const REGEX_DEVANAGARI = /[\u0900-\u097F]/;
const REGEX_LATIN_PROSE = /[A-Z][a-z]{2,}\s+[a-z]{2,}/;
const REGEX_PURE_ARABIC = /^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\s\d.,!?:;()[\]{}\-—"'/«»ـ]+$/;

const KNOWN_FONTS = new Set([
  'kalpurush', 'notosansbengali', 'amiri', 'uthmanic', 'roboto', 'poppins', 'inter', 'scheherazade'
]);

function tokenizeDartStrings(content) {
  const tokens = [];
  const len = content.length;
  let i = 0;
  while (i < len) {
    if (content[i] === '/' && content[i + 1] === '/') {
      while (i < len && content[i] !== '\n') i++;
      continue;
    }
    if (content[i] === '/' && content[i + 1] === '*') {
      i += 2;
      while (i < len && !(content[i] === '*' && content[i + 1] === '/')) i++;
      i += 2;
      continue;
    }
    if (content[i] === "'" || content[i] === '"') {
      const quoteChar = content[i];
      const isTriple = (i + 2 < len && content[i + 1] === quoteChar && content[i + 2] === quoteChar);
      const startPos = i;
      let strVal = '';
      if (isTriple) {
        i += 3;
        while (i < len) {
          if (content[i] === quoteChar && content[i + 1] === quoteChar && content[i + 2] === quoteChar) {
            i += 3;
            break;
          }
          if (content[i] === '\\') { strVal += content[i + 1] || ''; i += 2; continue; }
          strVal += content[i++];
        }
      } else {
        i++;
        while (i < len) {
          if (content[i] === quoteChar) { i++; break; }
          if (content[i] === '\\') { strVal += content[i + 1] || ''; i += 2; continue; }
          if (content[i] === '$' && content[i + 1] === '{') {
            i += 2;
            let braceCount = 1;
            while (i < len && braceCount > 0) {
              if (content[i] === '{') braceCount++;
              else if (content[i] === '}') braceCount--;
              i++;
            }
            continue;
          }
          strVal += content[i++];
        }
      }
      tokens.push({ strVal, startPos });
      continue;
    }
    i++;
  }
  return tokens;
}

function isInsideEnclosure(content, startPos) {
  const prefix = content.substring(Math.max(0, startPos - 120), startPos);
  const patterns = [
    /\b(?:assert|RegExp|Key|ValueKey|AssetImage|Icon|TextStyle)\s*\([^)]*$/,
    /\b(?:throw\s+(?:ArgumentError|Exception|StateError))\s*\([^)]*$/,
    /\b(?:t|tr|uiText|formatDigits)\s*\([^)]*$/
  ];
  return patterns.some(re => re.test(prefix));
}

function checkDartFile(filePath, masterKeys) {
  const content = fs.readFileSync(filePath, 'utf8');
  const tokens = tokenizeDartStrings(content);
  const violations = [];

  for (const { strVal, startPos } of tokens) {
    const trimmed = strVal.trim();
    if (!trimmed) continue;
    if (trimmed.startsWith('assets/') || trimmed.startsWith('package:') || trimmed.startsWith('http')) continue;
    if (REGEX_PURE_ARABIC.test(trimmed)) continue;
    if (KNOWN_FONTS.has(trimmed.toLowerCase())) continue;
    if (isInsideEnclosure(content, startPos)) continue;

    const hasBengali = REGEX_BENGALI.test(trimmed);
    const hasDeva = REGEX_DEVANAGARI.test(trimmed);
    const hasLatin = /[a-zA-Z]/.test(trimmed);

    // 1. Mixed Script
    if ((hasBengali && hasDeva) || ((hasBengali || hasDeva) && hasLatin && trimmed.length > 3)) {
      violations.push({ rule: 'CHECK_A_MIXED_SCRIPT', text: trimmed });
      continue;
    }

    // 2. Indic in Dart
    if (hasBengali || hasDeva) {
      violations.push({ rule: 'CHECK_A_INDIC_SCRIPT', text: trimmed });
      continue;
    }

    // 3. Latin Prose
    if (REGEX_LATIN_PROSE.test(trimmed) && trimmed.split(/\s+/).length >= 3) {
      violations.push({ rule: 'CHECK_A_LATIN_PROSE', text: trimmed });
      continue;
    }
  }

  // Model fields
  const fieldRegex = /(?:['"]|\b(?:this\.)?)(title|subtitle|description|desc|prompt|explanation|name|label)\b['"]?\s*[:=]\s*['"]([^'"]+)['"]/g;
  let fm;
  while ((fm = fieldRegex.exec(content)) !== null) {
    const val = fm[1].trim();
    if (val.includes('.') && !val.includes(' ')) continue; // translation key
    if (REGEX_PURE_ARABIC.test(val)) continue;
    violations.push({ rule: 'CHECK_A_MODEL_FIELD', text: val });
  }

  // Key usage
  const tRegex = /\b(?:context\.)?t\(\s*['"]([a-zA-Z0-9_\-.]+)['"]/g;
  let tm;
  while ((tm = tRegex.exec(content)) !== null) {
    const key = tm[1];
    if (masterKeys && !masterKeys.has(key)) {
      violations.push({ rule: 'CHECK_C_MISSING_KEY', text: key });
    }
  }

  return violations;
}

function runSelfTests() {
  console.log('================================================================');
  console.log('       CHECKER SELF-TEST: 8 BAD SAMPLES & 5 GOOD SAMPLES');
  console.log('================================================================\n');

  let passed = 0;
  let failed = 0;

  function assertRule(name, actualViolations, expectedRule) {
    const matched = actualViolations.some(v => v.rule === expectedRule);
    if (matched) {
      console.log(`✅ [PASS] ${name} -> Caught expected: ${expectedRule}`);
      passed++;
    } else {
      console.error(`❌ [FAIL] ${name} -> Expected ${expectedRule}, got: ${JSON.stringify(actualViolations)}`);
      failed++;
    }
  }

  function assertClean(name, actualViolations) {
    if (actualViolations.length === 0) {
      console.log(`✅ [PASS] ${name} -> Clean (0 violations)`);
      passed++;
    } else {
      console.error(`❌ [FAIL] ${name} -> Expected 0 violations, got: ${JSON.stringify(actualViolations)}`);
      failed++;
    }
  }

  const masterKeys = new Set(['common.ok', 'common.cancel']);

  // --- BAD SAMPLES ---
  console.log('--- Testing 8 Bad Samples ---');
  // 1. Indic in Dart
  const bad1 = checkDartFile(path.join(FIXTURES, 'bad_1_indic_in_dart.dart'), masterKeys);
  assertRule('bad_1_indic_in_dart.dart', bad1, 'CHECK_A_INDIC_SCRIPT');

  // 2. Latin prose in Dart
  const bad2 = checkDartFile(path.join(FIXTURES, 'bad_2_latin_prose.dart'), masterKeys);
  assertRule('bad_2_latin_prose.dart', bad2, 'CHECK_A_LATIN_PROSE');

  // 3. Mixed script
  const bad3 = checkDartFile(path.join(FIXTURES, 'bad_3_mixed_script.dart'), masterKeys);
  assertRule('bad_3_mixed_script.dart', bad3, 'CHECK_A_MIXED_SCRIPT');

  // 4. Model field with raw display text
  const bad4 = checkDartFile(path.join(FIXTURES, 'bad_4_model_field.dart'), masterKeys);
  assertRule('bad_4_model_field.dart', bad4, 'CHECK_A_MODEL_FIELD');

  // 5. Script purity in JSON (Bengali in Hindi file)
  const bad5Json = JSON.parse(fs.readFileSync(path.join(FIXTURES, 'bad_5_script_purity.json'), 'utf8'));
  const bad5Violations = [];
  for (const [k, v] of Object.entries(bad5Json)) {
    if (REGEX_BENGALI.test(v)) bad5Violations.push({ rule: 'CHECK_B_SCRIPT_PURITY', text: v });
  }
  assertRule('bad_5_script_purity.json', bad5Violations, 'CHECK_B_SCRIPT_PURITY');

  // 6. Placeholder mismatch
  const bad6Json = JSON.parse(fs.readFileSync(path.join(FIXTURES, 'bad_6_placeholder_mismatch.json'), 'utf8'));
  const bad6Violations = [];
  const getPh = s => (s.match(/\{+[a-zA-Z0-9_]+\}+/g) || []).map(m => m.replace(/[{}]/g, '')).sort().join(',');
  if (getPh(bad6Json.en) !== getPh(bad6Json.bn)) {
    bad6Violations.push({ rule: 'CHECK_B_PLACEHOLDER_PARITY', text: bad6Json.bn });
  }
  assertRule('bad_6_placeholder_mismatch.json', bad6Violations, 'CHECK_B_PLACEHOLDER_PARITY');

  // 7. Untranslated prose without same_as_en entry
  const bad7Json = JSON.parse(fs.readFileSync(path.join(FIXTURES, 'bad_7_untranslated.json'), 'utf8'));
  const bad7Violations = [];
  if (bad7Json.bn.trim() === bad7Json.en.trim() && bad7Json.bn.split(/\s+/).length >= 3) {
    bad7Violations.push({ rule: 'CHECK_B_UNTRANSLATED', text: bad7Json.bn });
  }
  assertRule('bad_7_untranslated.json', bad7Violations, 'CHECK_B_UNTRANSLATED');

  // 8. Missing key
  const bad8 = checkDartFile(path.join(FIXTURES, 'bad_8_missing_key.dart'), masterKeys);
  assertRule('bad_8_missing_key.dart', bad8, 'CHECK_C_MISSING_KEY');

  // 9. English sentence inside data-model constant list
  const bad9 = checkDartFile(path.join(FIXTURES, 'bad_9_constant_list_prose.dart'), masterKeys);
  assertRule('bad_9_constant_list_prose.dart', bad9, 'CHECK_A_LATIN_PROSE');

  // 10. Class with default parameter: {this.title = 'User Settings'}
  const bad10 = checkDartFile(path.join(FIXTURES, 'bad_10_default_param.dart'), masterKeys);
  assertRule('bad_10_default_param.dart', bad10, 'CHECK_A_MODEL_FIELD');

  // 11. Map literal: {'title': 'Welcome home', 'desc': 'Pehla sabak'}
  const bad11 = checkDartFile(path.join(FIXTURES, 'bad_11_map_literal.dart'), masterKeys);
  assertRule('bad_11_map_literal.dart', bad11, 'CHECK_A_MODEL_FIELD');

  // 12. Hindi/Bengali string inside a ternary and switch-case return
  const bad12 = checkDartFile(path.join(FIXTURES, 'bad_12_ternary_switch_indic.dart'), masterKeys);
  assertRule('bad_12_ternary_switch_indic.dart', bad12, 'CHECK_A_INDIC_SCRIPT');

  // --- GOOD SAMPLES ---
  console.log('\n--- Testing 5 Good Samples ---');
  // 1. Key lookup
  const good1 = checkDartFile(path.join(FIXTURES, 'good_1_key_lookup.dart'), masterKeys);
  assertClean('good_1_key_lookup.dart', good1);

  // 2. Pure Arabic
  const good2 = checkDartFile(path.join(FIXTURES, 'good_2_pure_arabic.dart'), masterKeys);
  assertClean('good_2_pure_arabic.dart', good2);

  // 3. Technical strings
  const good3 = checkDartFile(path.join(FIXTURES, 'good_3_technical_strings.dart'), masterKeys);
  assertClean('good_3_technical_strings.dart', good3);

  // 4. Assertions and Regex
  const good4 = checkDartFile(path.join(FIXTURES, 'good_4_assertions_and_regex.dart'), masterKeys);
  assertClean('good_4_assertions_and_regex.dart', good4);

  // 5. Valid Catalog Parity
  const good5Json = JSON.parse(fs.readFileSync(path.join(FIXTURES, 'good_5_valid_catalog.json'), 'utf8'));
  const good5Violations = [];
  const enPh = getPh(good5Json.en['alert.save']);
  for (const loc of ['bn', 'hi', 'it']) {
    if (getPh(good5Json[loc]['alert.save']) !== enPh) {
      good5Violations.push({ rule: 'CHECK_B_PLACEHOLDER_PARITY', text: good5Json[loc]['alert.save'] });
    }
  }
  assertClean('good_5_valid_catalog.json', good5Violations);

  console.log('\n================================================================');
  console.log(` SELF-TEST SUMMARY: ${passed} PASSED, ${failed} FAILED`);
  console.log('================================================================\n');

  if (failed > 0) process.exit(1);
}

runSelfTests();
