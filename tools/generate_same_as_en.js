const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const en = JSON.parse(fs.readFileSync(path.join(ROOT, 'locales', 'en.json'), 'utf8'));
const bn = JSON.parse(fs.readFileSync(path.join(ROOT, 'locales', 'bn.json'), 'utf8'));
const hi = JSON.parse(fs.readFileSync(path.join(ROOT, 'locales', 'hi.json'), 'utf8'));
const it = JSON.parse(fs.readFileSync(path.join(ROOT, 'locales', 'it.json'), 'utf8'));

function getLatinWords(val) {
  const stripped = val.replace(/\{\{[^}]+\}\}/g, '').replace(/\{[^}]+\}/g, '');
  return stripped.trim().split(/\s+/).filter(w => /[A-Za-z]/.test(w));
}

const map = {};

for (const [loc, cat] of Object.entries({ bn, hi, it })) {
  for (const [k, v] of Object.entries(cat)) {
    if (v === en[k] && typeof v === 'string') {
      const words = getLatinWords(v);
      if (words.length >= 2) {
        let reason = 'Proper noun / Islamic term';
        if (k.endsWith('.reference')) reason = 'Hadith source citation';
        else if (k.includes('qaida.step.') || k.includes('course.')) reason = 'Standard Arabic phonetic/tajweed transliteration';
        else if (k.startsWith('prayer.')) reason = 'Standard Islamic prayer terminology';
        map[k] = {
          value: v,
          reason: reason
        };
      }
    }
  }
}

fs.writeFileSync(path.join(ROOT, 'tools', 'i18n_same_as_en.json'), JSON.stringify(map, null, 2) + '\n', 'utf8');
console.log('Created tools/i18n_same_as_en.json with', Object.keys(map).length, 'entries.');
