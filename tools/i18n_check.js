#!/usr/bin/env node
/**
 * Strict i18n Safeguards & Quality Assurance Linter
 * 
 * Enforces Check A (Source Scan), Check B (Catalog Purity & Parity), and Check C (Key Usage)
 */

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const LOCALES = ['en', 'bn', 'hi', 'it'];

// Command-line flags
const args = process.argv.slice(2);
const writeReport = args.includes('--report');

// Data structures for tracking violations
const violations = []; // { rule, location, target, text }
const ruleCounts = {
  CHECK_A_INDIC_SCRIPT: 0,
  CHECK_A_LATIN_PROSE: 0,
  CHECK_A_MIXED_SCRIPT: 0,
  CHECK_A_MODEL_FIELD: 0,
  CHECK_B_KEY_PARITY: 0,
  CHECK_B_DUPLICATE_KEY: 0,
  CHECK_B_SCRIPT_PURITY: 0,
  CHECK_B_UNTRANSLATED: 0,
  CHECK_B_PLACEHOLDER_PARITY: 0,
  CHECK_B_EMPTY_OR_TODO: 0,
  CHECK_B_UNUSED_KEY: 0,
  CHECK_C_MISSING_KEY: 0,
  CHECK_C_DYNAMIC_KEY_EXISTS: 0,
};

function recordViolation(rule, location, target, text) {
  violations.push({ rule, location, target, text });
  if (ruleCounts[rule] !== undefined) {
    ruleCounts[rule]++;
  } else {
    ruleCounts[rule] = 1;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONFIGURATION LOADERS
// ─────────────────────────────────────────────────────────────────────────────
let allowlist = [];
const allowlistPath = path.join(ROOT, 'tools', 'i18n_allowlist.json');
if (fs.existsSync(allowlistPath)) {
  allowlist = JSON.parse(fs.readFileSync(allowlistPath, 'utf8'));
}

let sameAsEn = {};
const sameAsEnPath = path.join(ROOT, 'tools', 'i18n_same_as_en.json');
if (fs.existsSync(sameAsEnPath)) {
  sameAsEn = JSON.parse(fs.readFileSync(sameAsEnPath, 'utf8'));
}

let dynamicPrefixes = [];
const dynamicPrefixesPath = path.join(ROOT, 'tools', 'i18n_dynamic_prefixes.json');
if (fs.existsSync(dynamicPrefixesPath)) {
  dynamicPrefixes = JSON.parse(fs.readFileSync(dynamicPrefixesPath, 'utf8'));
}

// ─────────────────────────────────────────────────────────────────────────────
// SCRIPT REGEXES
// ─────────────────────────────────────────────────────────────────────────────
const REGEX_BENGALI = /[\u0980-\u09FF]/;
// Exclude Danda \u0964 and double danda \u0965 (shared Indic punctuation)
const REGEX_DEVANAGARI = /[\u0900-\u0963\u0966-\u097F]/;
const REGEX_ARABIC = /^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s\d.,!?:;'\-\(\)]+$/;
const REGEX_HAS_ARABIC = /[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]/;
const REGEX_LATIN = /[A-Za-z]/;

// Model fields forbidden to store non-Arabic display strings
const FORBIDDEN_MODEL_FIELDS = new Set([
  'title', 'subtitle', 'description', 'desc', 'name', 'label', 'reward', 'tip', 'rule', 'hint', 'instruction', 'message', 'prompt', 'explanation'
]);

// ─────────────────────────────────────────────────────────────────────────────
// CHECK A: SOURCE SCAN
// ─────────────────────────────────────────────────────────────────────────────
const KNOWN_FONTS = new Set([
  'Noto Sans Bengali', 'Hind Siliguri', 'Noto Sans Devanagari',
  'Noto Naskh Arabic', 'Amiri', 'Inter', 'Roboto', 'sans-serif'
]);

const TECHNICAL_LITERALS = new Set([
  'Accept', 'Authorization', 'Bearer', 'Content-Type', 'application/json',
  'Meccan', 'Medinan', 'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha', 'Sunrise',
  'Bengali', 'English', 'Hindi', 'Italian', 'Italiano', 'বাংলা', 'हिन्दी',
  'Al-Fatiha', 'Al-Baqarah', "Ali 'Imran", 'Yusuf', 'Fussilat'
]);

function isTechnicalToken(token, contextLine = '') {
  if (KNOWN_FONTS.has(token) || TECHNICAL_LITERALS.has(token)) return true;
  if (/^[\s\d:·\-_|/\\.,;!?()[\]{}#*+=%~^$<>]+$/.test(token)) return true;
  // 1. Asset paths, file extensions, imports
  if (/^(assets\/|packages\/|\/|[a-zA-Z0-9_\-\.\/]+\.(png|jpg|jpeg|svg|mp3|wav|json|arb|dart))$/.test(token)) {
    return true;
  }
  // 2. URLs and emails
  if (/^(https?:\/\/|mailto:|[\w.-]+@[\w.-]+\.\w+)/.test(token)) {
    return true;
  }
  // 3. Route names starting with /
  if (token.startsWith('/') && !token.includes(' ')) {
    return true;
  }
  // 4. snake_case / camelCase / dot.notation identifiers without spaces
  if (/^[a-zA-Z0-9_\-]+(\.[a-zA-Z0-9_\-]+)+$/.test(token) || /^[a-z]+[a-zA-Z0-9_]*$/.test(token) || /^[A-Z0-9_]+$/.test(token)) {
    return true;
  }
  if (token.endsWith('.') && /^[a-zA-Z0-9_\-]+(\.[a-zA-Z0-9_\-]+)*\.$/.test(token)) {
    return true;
  }
  // 5. Intl/date patterns and locale codes
  if (/^(yyyy|MM|dd|HH|mm|ss|EEE|MMM|en|bn|hi|it|ar)+[-_/:,\s]*[a-zA-Z0-9\-_/:,\s]*$/.test(token) && token.length <= 16) {
    return true;
  }
  if (['en', 'bn', 'hi', 'it', 'ar', 'USD', 'BDT', 'INR', 'EUR', 'LTR', 'RTL'].includes(token)) {
    return true;
  }
  // 6. Font family names
  if (contextLine.includes('fontFamily') || contextLine.includes('GoogleFonts.')) {
    return true;
  }
  return false;
}

function isProse(literal) {
  const trimmed = literal.trim();
  if (!REGEX_LATIN.test(trimmed)) return false;
  if (isTechnicalToken(trimmed)) return false;

  const words = trimmed.split(/\s+/).filter(w => REGEX_LATIN.test(w));
  if (words.length >= 2) {
    if (words.every(w => w.length <= 2)) return false;
    return true;
  }
  if (words.length === 1) {
    const w = words[0];
    if (/[.!?:]$/.test(trimmed)) return true;
    if (trimmed.includes(' ')) return true;
    // Capitalized single word that is not an enum or identifier
    if (/^[A-Z][a-z]{3,}$/.test(w) && !['Admin', 'User', 'Guest', 'Success', 'Error', 'Failed', 'Test', 'Mock'].includes(w)) {
      return true;
    }
  }
  return false;
}

function isAllowlisted(relPath, lineNum, literal) {
  const normPath = relPath.replace(/\\/g, '/');
  return allowlist.some(entry => {
    const entryPath = entry.file.replace(/\\/g, '/');
    return entryPath === normPath && entry.line === lineNum && entry.literal === literal;
  });
}

function isInsideEnclosure(code, quoteIdx, funcNames) {
  for (const fn of funcNames) {
    const lastCall = code.lastIndexOf(fn + '(', quoteIdx);
    if (lastCall !== -1) {
      const lastSemi = code.lastIndexOf(';', quoteIdx);
      if (lastSemi <= lastCall) {
        let openParen = 1;
        for (let j = lastCall + fn.length + 1; j < quoteIdx; j++) {
          if (code[j] === '(') openParen++;
          else if (code[j] === ')') openParen--;
        }
        if (openParen > 0) return true;
      }
    }
  }
  return false;
}

const SKIP_ENCLOSURES = [
  'assert', 'RegExp', 'throw', 'Exception', 'FormatException',
  'ArgumentError', 'StateError', 'UnsupportedError', 'ClientException',
  'AssertionError', 'PrayerTimesException', 'FlutterError', 'print', 'debugPrint',
  'Key', 't', 'tr', 'uiText'
];

function tokenizeDartStrings(code) {
  const literals = [];
  let i = 0;
  let line = 1;

  while (i < code.length) {
    const c = code[i];

    if (c === '\n') {
      line++;
      i++;
      continue;
    }

    if (c === '/' && code[i + 1] === '/') {
      while (i < code.length && code[i] !== '\n') i++;
      continue;
    }

    if (c === '/' && code[i + 1] === '*') {
      i += 2;
      while (i < code.length && !(code[i] === '*' && code[i + 1] === '/')) {
        if (code[i] === '\n') line++;
        i++;
      }
      i += 2;
      continue;
    }

    let isRaw = false;
    let quoteChar = null;
    let isTriple = false;
    const quoteStartIdx = i;

    if (c === 'r' && (code[i + 1] === '\'' || code[i + 1] === '"')) {
      isRaw = true;
      quoteChar = code[i + 1];
      if (code[i + 2] === quoteChar && code[i + 3] === quoteChar) {
        isTriple = true;
        i += 4;
      } else {
        i += 2;
      }
    } else if (c === '\'' || c === '"') {
      quoteChar = c;
      if (code[i + 1] === quoteChar && code[i + 2] === quoteChar) {
        isTriple = true;
        i += 3;
      } else {
        i += 1;
      }
    }

    if (quoteChar) {
      const strStartLine = line;
      const prefixStart = Math.max(0, isRaw ? i - 52 : i - 51);
      const prefix = code.substring(prefixStart, isRaw ? i - 2 : i - 1);

      let strContent = '';
      while (i < code.length) {
        if (!isRaw && code[i] === '\\') {
          strContent += code[i + 1];
          i += 2;
          continue;
        }

        if (isTriple) {
          if (code[i] === quoteChar && code[i + 1] === quoteChar && code[i + 2] === quoteChar) {
            i += 3;
            break;
          }
        } else {
          if (code[i] === quoteChar) {
            i += 1;
            break;
          }
        }

        if (code[i] === '\n') line++;

        if (!isRaw && code[i] === '$' && code[i + 1] === '{') {
          let braceCount = 1;
          i += 2;
          let interpCode = '';
          while (i < code.length && braceCount > 0) {
            if (code[i] === '{') braceCount++;
            else if (code[i] === '}') braceCount--;
            if (braceCount > 0) interpCode += code[i];
            if (code[i] === '\n') line++;
            i++;
          }
          const innerLiterals = tokenizeDartStrings(interpCode);
          innerLiterals.forEach(lit => {
            literals.push({
              literal: lit.literal,
              line: strStartLine,
              prefix: lit.prefix,
              quoteIdx: quoteStartIdx
            });
          });
          continue;
        }

        if (!isRaw && code[i] === '$' && /[a-zA-Z0-9_]/.test(code[i + 1])) {
          i += 2;
          while (i < code.length && /[a-zA-Z0-9_]/.test(code[i])) i++;
          continue;
        }

        strContent += code[i];
        i++;
      }

      literals.push({
        literal: strContent.trim(),
        line: strStartLine,
        prefix: prefix,
        quoteIdx: quoteStartIdx
      });
      continue;
    }

    i++;
  }

  return literals;
}

function scanSourceFiles() {
  const dartFiles = [];
  function walkDir(dir) {
    if (!fs.existsSync(dir)) return;
    const entries = fs.readdirSync(dir);
    for (const e of entries) {
      const full = path.join(dir, e);
      const stat = fs.statSync(full);
      if (stat.isDirectory()) {
        walkDir(full);
      } else if (e.endsWith('.dart')) {
        dartFiles.push(full);
      }
    }
  }
  walkDir(path.join(ROOT, 'lib'));

  for (const file of dartFiles) {
    const relPath = path.relative(ROOT, file).replace(/\\/g, '/');
    if (relPath.includes('static_translations.dart')) continue;
    if (relPath === 'lib/core/localization/app_languages.dart') continue;

    const rawContent = fs.readFileSync(file, 'utf8');
    const tokens = tokenizeDartStrings(rawContent);

    for (const tok of tokens) {
      const lineNum = tok.line;
      let literal = tok.literal;
      if (!literal) continue;

      const prefix = tok.prefix;

      if (
        /\b(t|tr|uiText|Key|debugPrint|print|assert|throw|Exception|FormatException|ArgumentError|StateError|UnsupportedError|ClientException|AssertionError|PrayerTimesException|FlutterError|RegExp)\s*\(\s*$/.test(prefix) ||
        /\b(?:assert|throw|RegExp|FlutterError)\s*\(.*,\s*$/.test(prefix) ||
        /\bl10n\.[a-zA-Z0-9_]+\s*\(\s*$/.test(prefix) ||
        /@RoutePage|@pragma/.test(prefix) ||
        isInsideEnclosure(rawContent, tok.quoteIdx, SKIP_ENCLOSURES)
      ) {
        continue;
      }

      if (isAllowlisted(relPath, lineNum, literal)) {
        continue;
      }

      const hasBengali = REGEX_BENGALI.test(literal);
      const hasDevanagari = REGEX_DEVANAGARI.test(literal);
      const hasArabic = REGEX_HAS_ARABIC.test(literal);
      const isPureArabic = hasArabic && REGEX_ARABIC.test(literal);

      // Model field check: e.g. title: '...', this.title = '...', 'title': '...'
      const fieldMatch = prefix.match(/(?:['"]|\b(?:this\.)?)([a-zA-Z0-9_]+)['"]?\s*[:=]\s*$/);
      if (fieldMatch) {
        const fieldName = fieldMatch[1];
        if (FORBIDDEN_MODEL_FIELDS.has(fieldName) && !isPureArabic && !isTechnicalToken(literal, prefix)) {
          recordViolation(
            'CHECK_A_MODEL_FIELD',
            `${relPath}:${lineNum}`,
            fieldName,
            `Field '${fieldName}' initialized with display string '${literal}' instead of *Key`
          );
          continue;
        }
      }

      // 1. Check Indic script leakage
      if (hasBengali || hasDevanagari) {
        recordViolation(
          'CHECK_A_INDIC_SCRIPT',
          `${relPath}:${lineNum}`,
          hasBengali ? 'Bengali' : 'Devanagari',
          literal
        );
        continue;
      }

      // 2. Pure Arabic check
      if (isPureArabic) {
        continue;
      }

      // 3. Mixed Arabic + Latin check
      if (hasArabic && REGEX_LATIN.test(literal)) {
        recordViolation(
          'CHECK_A_MIXED_SCRIPT',
          `${relPath}:${lineNum}`,
          'Mixed Script',
          literal
        );
        continue;
      }

      // 4. Latin prose check
      if (isProse(literal)) {
        recordViolation(
          'CHECK_A_LATIN_PROSE',
          `${relPath}:${lineNum}`,
          'Latin Prose',
          literal
        );
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CHECK B: LOCALE FILE CONTENT
// ─────────────────────────────────────────────────────────────────────────────
function checkDuplicateKeysInFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  let depth = 0;
  let inString = false;
  let escape = false;
  let currentKey = '';
  const seen = new Set();
  const duplicates = [];

  for (let i = 0; i < content.length; i++) {
    const c = content[i];
    if (escape) {
      escape = false;
      continue;
    }
    if (c === '\\') {
      escape = true;
      continue;
    }
    if (c === '"') {
      inString = !inString;
      if (inString) {
        currentKey = '';
      } else {
        let j = i + 1;
        while (j < content.length && (content[j] === ' ' || content[j] === '\t' || content[j] === '\n' || content[j] === '\r')) j++;
        if (depth === 1 && content[j] === ':') {
          if (seen.has(currentKey)) {
            duplicates.push(currentKey);
          }
          seen.add(currentKey);
        }
      }
      continue;
    }
    if (inString) {
      currentKey += c;
      continue;
    }
    if (c === '{') depth++;
    if (c === '}') depth--;
  }

  if (duplicates.length > 0) {
    const rel = path.relative(ROOT, filePath).replace(/\\/g, '/');
    duplicates.forEach(k => {
      recordViolation('CHECK_B_DUPLICATE_KEY', rel, k, `Duplicate top-level key: ${k}`);
    });
  }
}

function getPlaceholders(s) {
  if (typeof s !== 'string') return [];
  const matches = s.match(/\{+[a-zA-Z0-9_]+\}+/g) || [];
  return matches.map(m => m.replace(/[\{\}]/g, '')).sort();
}

function checkLocaleFiles() {
  const catalogs = {
    json: {},
    assetsJson: {},
    arb: {},
    staticTranslations: {},
  };

  // 1. Load locales/*.json
  for (const loc of LOCALES) {
    const p = path.join(ROOT, 'locales', `${loc}.json`);
    checkDuplicateKeysInFile(p);
    catalogs.json[loc] = JSON.parse(fs.readFileSync(p, 'utf8'));
  }

  // 2. Load assets/locales/*.json
  for (const loc of LOCALES) {
    const p = path.join(ROOT, 'assets', 'locales', `${loc}.json`);
    checkDuplicateKeysInFile(p);
    catalogs.assetsJson[loc] = JSON.parse(fs.readFileSync(p, 'utf8'));
  }

  // 3. Load assets/l10n/app_*.arb
  for (const loc of LOCALES) {
    const p = path.join(ROOT, 'assets', 'l10n', `app_${loc}.arb`);
    checkDuplicateKeysInFile(p);
    const data = JSON.parse(fs.readFileSync(p, 'utf8'));
    const filtered = {};
    for (const [k, v] of Object.entries(data)) {
      if (!k.startsWith('@') && k !== '@@locale') filtered[k] = v;
    }
    catalogs.arb[loc] = filtered;
  }

  // 4. Load lib/l10n/static_translations.dart
  const staticPath = path.join(ROOT, 'lib', 'l10n', 'static_translations.dart');
  const staticContent = fs.readFileSync(staticPath, 'utf8');
  for (const loc of LOCALES) {
    const marker = `"${loc}": {`;
    const startIdx = staticContent.indexOf(marker);
    if (startIdx === -1) {
      recordViolation('CHECK_B_KEY_PARITY', 'lib/l10n/static_translations.dart', loc, `Missing "${loc}" map in static_translations.dart`);
      catalogs.staticTranslations[loc] = {};
      continue;
    }
    const endIdx = staticContent.indexOf('  },', startIdx);
    const block = staticContent.substring(startIdx + marker.length, endIdx !== -1 ? endIdx : staticContent.indexOf('};', startIdx));
    const entries = {};
    const keyValRegex = /"([^"]+)":\s*"((?:\\.|[^"\\])*)"/g;
    let m;
    while ((m = keyValRegex.exec(block)) !== null) {
      entries[m[1]] = m[2];
    }
    catalogs.staticTranslations[loc] = entries;
  }

  // Check key parity across all catalogs vs locales/en.json
  const masterKeys = new Set(Object.keys(catalogs.json.en));

  for (const loc of LOCALES) {
    // locales/*.json
    const jsonKeys = new Set(Object.keys(catalogs.json[loc]));
    for (const k of masterKeys) {
      if (!jsonKeys.has(k)) {
        recordViolation('CHECK_B_KEY_PARITY', `locales/${loc}.json`, k, `Missing key '${k}'`);
      }
    }

    // assets/locales/*.json
    const assetsJsonKeys = new Set(Object.keys(catalogs.assetsJson[loc]));
    for (const k of masterKeys) {
      if (!assetsJsonKeys.has(k)) {
        recordViolation('CHECK_B_KEY_PARITY', `assets/locales/${loc}.json`, k, `Missing key '${k}'`);
      }
    }

    // assets/l10n/app_*.arb
    const arbKeys = new Set(Object.keys(catalogs.arb[loc]));
    for (const k of masterKeys) {
      if (!arbKeys.has(k)) {
        recordViolation('CHECK_B_KEY_PARITY', `assets/l10n/app_${loc}.arb`, k, `Missing key '${k}'`);
      }
    }

    // static_translations.dart
    const staticKeys = new Set(Object.keys(catalogs.staticTranslations[loc]));
    for (const k of masterKeys) {
      if (!staticKeys.has(k)) {
        recordViolation('CHECK_B_KEY_PARITY', `static_translations.dart[${loc}]`, k, `Missing key '${k}'`);
      }
    }
  }

  // Script purity of VALUES & Untranslated checks
  const enCatalog = catalogs.json.en;

  for (const loc of LOCALES) {
    const cat = catalogs.json[loc];
    for (const [k, v] of Object.entries(cat)) {
      if (typeof v !== 'string') continue;

      // Empty / TODO check
      if (!v.trim() || /^(TODO|TBD|\?{2,}|lorem)/i.test(v.trim())) {
        recordViolation('CHECK_B_EMPTY_OR_TODO', `locales/${loc}.json`, k, `Value is empty or placeholder: '${v}'`);
      }

      // Script purity
      if (loc === 'en') {
        if (REGEX_BENGALI.test(v)) {
          recordViolation('CHECK_B_SCRIPT_PURITY', `locales/en.json`, k, `Bengali in English value: '${v}'`);
        }
        if (REGEX_DEVANAGARI.test(v)) {
          recordViolation('CHECK_B_SCRIPT_PURITY', `locales/en.json`, k, `Devanagari in English value: '${v}'`);
        }
      } else if (loc === 'bn') {
        if (REGEX_DEVANAGARI.test(v)) {
          recordViolation('CHECK_B_SCRIPT_PURITY', `locales/bn.json`, k, `Devanagari in Bengali value: '${v}'`);
        }
      } else if (loc === 'hi') {
        if (REGEX_BENGALI.test(v)) {
          recordViolation('CHECK_B_SCRIPT_PURITY', `locales/hi.json`, k, `Bengali in Hindi value: '${v}'`);
        }
      } else if (loc === 'it') {
        if (REGEX_BENGALI.test(v) || REGEX_DEVANAGARI.test(v)) {
          recordViolation('CHECK_B_SCRIPT_PURITY', `locales/it.json`, k, `Indic script in Italian value: '${v}'`);
        }
      }

      // Placeholder parity vs en
      const enVal = enCatalog[k];
      if (enVal !== undefined) {
        const enPh = getPlaceholders(enVal).join(',');
        const locPh = getPlaceholders(v).join(',');
        if (enPh !== locPh) {
          recordViolation('CHECK_B_PLACEHOLDER_PARITY', `locales/${loc}.json`, k, `Placeholders mismatch: en='${enPh}', ${loc}='${locPh}'`);
        }
      }

      // Untranslated detection
      if (loc !== 'en' && enVal !== undefined && v.trim() === enVal.trim()) {
        const stripped = v.replace(/\{\{[^}]+\}\}/g, '').replace(/\{[^}]+\}/g, '').trim();
        const words = stripped.split(/\s+/).filter(w => REGEX_LATIN.test(w));
        if (words.length >= 2) {
          if (!sameAsEn[k]) {
            recordViolation('CHECK_B_UNTRANSLATED', `locales/${loc}.json`, k, `Value identical to English without i18n_same_as_en.json entry: '${v}'`);
          }
        }
      }
    }
  }

  // Unused keys check
  const sourceContents = [];
  function gatherSources(dir) {
    if (!fs.existsSync(dir)) return;
    const entries = fs.readdirSync(dir);
    for (const e of entries) {
      const full = path.join(dir, e);
      const stat = fs.statSync(full);
      if (stat.isDirectory()) {
        gatherSources(full);
      } else if (e.endsWith('.dart') && e !== 'static_translations.dart') {
        sourceContents.push(fs.readFileSync(full, 'utf8'));
      }
    }
  }
  gatherSources(path.join(ROOT, 'lib'));
  const allDartCode = sourceContents.join('\n');

  for (const k of masterKeys) {
    if (dynamicPrefixes.some(p => k.startsWith(p))) continue;
    if (!allDartCode.includes(k)) {
      recordViolation('CHECK_B_UNUSED_KEY', 'locales/en.json', k, `Translation key '${k}' is not referenced in lib/`);
    }
  }

  return masterKeys;
}

// ─────────────────────────────────────────────────────────────────────────────
// CHECK C: KEY USAGE
// ─────────────────────────────────────────────────────────────────────────────
function checkKeyUsage(masterKeys) {
  function scanDir(dir) {
    if (!fs.existsSync(dir)) return;
    const entries = fs.readdirSync(dir);
    for (const e of entries) {
      const full = path.join(dir, e);
      const stat = fs.statSync(full);
      if (stat.isDirectory()) {
        scanDir(full);
      } else if (e.endsWith('.dart') && e !== 'static_translations.dart') {
        const rawContent = fs.readFileSync(full, 'utf8');
        const rel = path.relative(ROOT, full).replace(/\\/g, '/');

        // Strip single-line comments and doc comments so doc examples aren't parsed as active calls
        const lines = rawContent.split('\n');
        const codeLines = lines.map(line => {
          const trimmed = line.trim();
          if (trimmed.startsWith('//') || trimmed.startsWith('///') || trimmed.startsWith('*') || trimmed.startsWith('/*')) {
            return '';
          }
          return line;
        });
        const content = codeLines.join('\n');

        // Match context.t('key') or t('key')
        const tCallRegex = /\b(?:context\.)?t\(\s*['"]([a-zA-Z0-9_\-.]+)['"]/g;
        let m;
        while ((m = tCallRegex.exec(content)) !== null) {
          const key = m[1];
          if (!masterKeys.has(key)) {
            // Check dynamic prefix
            if (!dynamicPrefixes.some(p => key.startsWith(p))) {
              recordViolation('CHECK_C_MISSING_KEY', rel, key, `Referenced key '${key}' does not exist in locales/en.json`);
            }
          }
        }

        // Match model key properties: descriptionKey, titleKey, subtitleKey, etc.
        const keyRefRegex = /\b(?:descriptionKey|titleKey|phaseNameKey|gardenPlantKey|subtitleKey)\s*:\s*['"]([a-zA-Z0-9_\-.]+)['"]/g;
        while ((m = keyRefRegex.exec(content)) !== null) {
          const key = m[1];
          if (!masterKeys.has(key)) {
            recordViolation('CHECK_C_MISSING_KEY', rel, key, `Referenced model key '${key}' does not exist in locales/en.json`);
          }
        }
      }
    }
  }
  scanDir(path.join(ROOT, 'lib'));
}

function checkDynamicKeyExpansion(masterKeys) {
  console.log('\n--- DYNAMIC KEY EXPANSION (CHECK_C_DYNAMIC_KEY_EXISTS) ---');
  const enCatalogPath = path.join(ROOT, 'locales', 'en.json');
  const en = JSON.parse(fs.readFileSync(enCatalogPath, 'utf8'));

  const patterns = {};
  for (const prop of ['desc', 'title', 'phase_name', 'garden_plant']) {
    patterns[`qaida.step.$n.${prop}`] = Array.from({ length: 17 }, (_, i) => `qaida.step.${i + 1}.${prop}`);
  }
  for (const prop of ['name', 'meaning']) {
    patterns[`quran.surah.$n.${prop}`] = Array.from({ length: 114 }, (_, i) => `quran.surah.${i + 1}.${prop}`);
  }
  patterns['hijri.month.$n'] = Array.from({ length: 12 }, (_, i) => `hijri.month.${i + 1}`);
  const prayerMethods = [0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
  patterns['prayer.method.$id'] = prayerMethods.map(id => `prayer.method.${id}`);
  const actTypes = Object.keys(en).filter(k => k.startsWith('qaida.activity_type.'));
  patterns['qaida.activity_type.$type'] = actTypes;
  patterns['qaida.letter.$id.*'] = Object.keys(en).filter(k => k.startsWith('qaida.letter.'));
  patterns['duas.item.$id.*'] = Object.keys(en).filter(k => k.startsWith('duas.item.'));
  patterns['seerah.story.$id.*'] = Object.keys(en).filter(k => k.startsWith('seerah.story.'));

  let totalExpanded = 0;
  for (const [pattern, keys] of Object.entries(patterns)) {
    totalExpanded += keys.length;
    let missingCount = 0;
    for (const key of keys) {
      if (!masterKeys.has(key)) {
        missingCount++;
        recordViolation('CHECK_C_DYNAMIC_KEY_EXISTS', 'dynamic', key, `Expanded key '${key}' for pattern '${pattern}' does not exist in locales/en.json`);
      }
    }
    const status = missingCount === 0 ? `✅ ${keys.length}/${keys.length} keys verified` : `❌ ${missingCount} keys missing!`;
    console.log(`  Pattern ${pattern.padEnd(28)} : ${status}`);
  }
  console.log(`Total dynamic keys expanded & verified: ${totalExpanded}\n`);
}

// ─────────────────────────────────────────────────────────────────────────────
// RUN ALL CHECKS
// ─────────────────────────────────────────────────────────────────────────────
console.log('================================================================');
console.log('         LITTLE MUSLIM COMPREHENSIVE i18n VALIDATOR');
console.log('================================================================\n');

scanSourceFiles();
const masterKeys = checkLocaleFiles();
checkKeyUsage(masterKeys);
checkDynamicKeyExpansion(masterKeys);

// ─────────────────────────────────────────────────────────────────────────────
// PRINT RESULTS & WRITE REPORT
// ─────────────────────────────────────────────────────────────────────────────
console.log('\n--- AUDIT RESULTS PER RULE ---');
for (const [rule, count] of Object.entries(ruleCounts)) {
  const icon = count === 0 ? '✅' : '❌';
  console.log(`${icon} ${rule.padEnd(30)} : ${count} violation(s)`);
}

if (violations.length > 0) {
  console.log('\n--- DETAILED VIOLATIONS ---');
  violations.slice(0, 50).forEach(v => {
    console.log(`${v.rule} | ${v.location} | ${v.target} | ${v.text}`);
  });
  if (violations.length > 50) {
    console.log(`... and ${violations.length - 50} more violations.`);
  }
}

if (writeReport) {
  const reportPath = path.join(ROOT, 'docs', 'i18n-check-report.md');
  const now = new Date().toISOString();
  let markdown = `# i18n Quality Assurance & Check Report\n\n`;
  markdown += `**Generated At**: ${now}\n`;
  markdown += `**Total Violations**: ${violations.length}\n\n`;
  markdown += `## Rule Summary\n\n`;
  markdown += `| Rule | Violations | Status |\n`;
  markdown += `| :--- | :---: | :---: |\n`;
  for (const [rule, count] of Object.entries(ruleCounts)) {
    markdown += `| \`${rule}\` | ${count} | ${count === 0 ? 'PASSED ✅' : 'FAILED ❌'} |\n`;
  }
  markdown += `\n## Detailed Violations\n\n`;
  if (violations.length === 0) {
    markdown += `*Zero violations detected. All source files and catalogs adhere strictly to internationalization safeguards.*\n`;
  } else {
    markdown += `| Rule | Location | Target | Offending Text |\n`;
    markdown += `| :--- | :--- | :--- | :--- |\n`;
    violations.forEach(v => {
      const sanitized = v.text.replace(/\|/g, '\\|').replace(/\n/g, ' ');
      markdown += `| \`${v.rule}\` | \`${v.location}\` | \`${v.target}\` | ${sanitized} |\n`;
    });
  }
  fs.writeFileSync(reportPath, markdown, 'utf8');
  console.log(`\n📄 Report written to ${path.relative(ROOT, reportPath)}`);
}

console.log('\n================================================================');
if (violations.length === 0) {
  console.log(' 🎉 ALL i18n SAFEGUARDS PASSED CLEANLY (0 VIOLATIONS)');
  console.log('================================================================\n');
  process.exit(0);
} else {
  console.error(` ❌ FAILED WITH ${violations.length} VIOLATION(S)`);
  console.log('================================================================\n');
  process.exit(1);
}
