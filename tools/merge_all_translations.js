const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const LOCALES = ['en', 'bn', 'hi', 'it'];

const commonStrings = JSON.parse(fs.readFileSync(path.join(ROOT, 'tools', 'scratch_common_strings.json'), 'utf8'));
const chapterTranslations = JSON.parse(fs.readFileSync(path.join(ROOT, 'tools', 'scratch_chapter_translations.json'), 'utf8'));

// Build complete new key-value map for each locale
const newKeys = { en: {}, bn: {}, hi: {}, it: {} };

// 1. Common & template strings
for (const [k, obj] of Object.entries(commonStrings)) {
  for (const loc of LOCALES) {
    newKeys[loc][k] = obj[loc];
  }
}

// 2. Chapters
for (const [chId, data] of Object.entries(chapterTranslations)) {
  for (const loc of LOCALES) {
    newKeys[loc][`basics.chapter.${chId}.title`] = data.title[loc];
    newKeys[loc][`basics.chapter.${chId}.definition`] = data.definition[loc];
    newKeys[loc][`basics.chapter.${chId}.story`] = data.story[loc];
  }
  data.quiz.forEach((qItem, idx) => {
    const qNum = idx + 1;
    for (const loc of LOCALES) {
      newKeys[loc][`basics.chapter.${chId}.quiz.${qNum}.q`] = qItem.q[loc];
      newKeys[loc][`basics.chapter.${chId}.quiz.${qNum}.a`] = qItem.a[loc];
    }
  });
}

console.log('Total new keys to merge:', Object.keys(newKeys.en).length);

// Merge into locales/*.json
for (const loc of LOCALES) {
  const p = path.join(ROOT, 'locales', `${loc}.json`);
  const data = JSON.parse(fs.readFileSync(p, 'utf8'));
  Object.assign(data, newKeys[loc]);
  fs.writeFileSync(p, JSON.stringify(data, null, 2) + '\n', 'utf8');
}

// Merge into assets/locales/*.json
for (const loc of LOCALES) {
  const p = path.join(ROOT, 'assets', 'locales', `${loc}.json`);
  const data = JSON.parse(fs.readFileSync(p, 'utf8'));
  Object.assign(data, newKeys[loc]);
  fs.writeFileSync(p, JSON.stringify(data, null, 2) + '\n', 'utf8');
}

// Merge into assets/l10n/app_*.arb
for (const loc of LOCALES) {
  const p = path.join(ROOT, 'assets', 'l10n', `app_${loc}.arb`);
  const data = JSON.parse(fs.readFileSync(p, 'utf8'));
  for (const [k, v] of Object.entries(newKeys[loc])) {
    data[k] = v;
    if (loc === 'en' && !data[`@${k}`]) {
      data[`@${k}`] = { description: `Translation for ${k}` };
    }
  }
  fs.writeFileSync(p, JSON.stringify(data, null, 2) + '\n', 'utf8');
}

// Regenerate lib/l10n/static_translations.dart
const enData = JSON.parse(fs.readFileSync(path.join(ROOT, 'locales', 'en.json'), 'utf8'));
const bnData = JSON.parse(fs.readFileSync(path.join(ROOT, 'locales', 'bn.json'), 'utf8'));
const hiData = JSON.parse(fs.readFileSync(path.join(ROOT, 'locales', 'hi.json'), 'utf8'));
const itData = JSON.parse(fs.readFileSync(path.join(ROOT, 'locales', 'it.json'), 'utf8'));

function escapeDart(val) {
  return val
    .replace(/\\/g, '\\\\')
    .replace(/"/g, '\\"')
    .replace(/\$/g, '\\$')
    .replace(/\n/g, '\\n')
    .replace(/\r/g, '\\r');
}

function generateMap(catalog) {
  const lines = [];
  for (const [k, v] of Object.entries(catalog)) {
    lines.push(`    "${escapeDart(k)}": "${escapeDart(v)}",`);
  }
  return lines.join('\n');
}

const dartContent = `// GENERATED FILE - DO NOT MODIFY DIRECTLY
// Synchronized from locales/*.json
// Total entries: ${Object.keys(enData).length} per language

const Map<String, Map<String, String>> staticTranslations = {
  "en": {
${generateMap(enData)}
  },
  "bn": {
${generateMap(bnData)}
  },
  "hi": {
${generateMap(hiData)}
  },
  "it": {
${generateMap(itData)}
  },
};
`;

fs.writeFileSync(path.join(ROOT, 'lib', 'l10n', 'static_translations.dart'), dartContent, 'utf8');
console.log('Successfully updated locales/*.json, assets/locales/*.json, assets/l10n/*.arb, and static_translations.dart');
