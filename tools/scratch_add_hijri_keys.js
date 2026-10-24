const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const LOCALES = ['en', 'bn', 'hi', 'it'];

const hijriAndDurationKeys = {
  'hijri.month.1': { en: 'Muharram', bn: 'মুহররম', hi: 'मुहर्रम', it: 'Muharram' },
  'hijri.month.2': { en: 'Safar', bn: 'সফর', hi: 'सफ़र', it: 'Safar' },
  'hijri.month.3': { en: "Rabi' al-Awwal", bn: 'রবিউল আউয়াল', hi: 'रबी उल-अव्वल', it: "Rabi' al-Awwal" },
  'hijri.month.4': { en: "Rabi' al-Thani", bn: 'রবিউস সানি', hi: 'रबी उल-थानी', it: "Rabi' al-Thani" },
  'hijri.month.5': { en: 'Jumada al-Awwal', bn: 'জমাদিউল আউয়াল', hi: 'जुमादा अल-अव्वल', it: 'Jumada al-Awwal' },
  'hijri.month.6': { en: 'Jumada al-Thani', bn: 'জমাদিউস সানি', hi: 'जुमादा अल-थानी', it: 'Jumada al-Thani' },
  'hijri.month.7': { en: 'Rajab', bn: 'রজব', hi: 'रजब', it: 'Rajab' },
  'hijri.month.8': { en: "Sha'ban", bn: 'শাবান', hi: 'शाबान', it: "Sha'ban" },
  'hijri.month.9': { en: 'Ramadan', bn: 'রমজান', hi: 'रमज़ान', it: 'Ramadan' },
  'hijri.month.10': { en: 'Shawwal', bn: 'শাওয়াল', hi: 'शव्वाल', it: 'Shawwal' },
  'hijri.month.11': { en: "Dhul Qi'dah", bn: 'জিলক্বদ', hi: 'धुल क़ादा', it: "Dhul Qi'dah" },
  'hijri.month.12': { en: 'Dhul Hijjah', bn: 'জিলহজ্ব', hi: 'धুল हिज्जा', it: 'Dhul Hijjah' },
  'duration.hours_minutes': {
    en: '{hours} {hourWord} {minutes} mins',
    bn: '{hours} ঘণ্টা {minutes} মিনিট',
    hi: '{hours} घंटे {minutes} मिनट',
    it: '{hours} ore {minutes} min'
  },
  'duration.hours': {
    en: '{hours} {hourWord}',
    bn: '{hours} ঘণ্টা',
    hi: '{hours} घंटे',
    it: '{hours} ore'
  },
  'duration.minutes': {
    en: '{minutes} mins',
    bn: '{minutes} মিনিট',
    hi: '{minutes} মিনিট',
    it: '{minutes} min'
  },
  'duration.hr': {
    en: 'hr',
    bn: 'ঘণ্টা',
    hi: 'घंटा',
    it: 'ora'
  },
  'duration.hrs': {
    en: 'hrs',
    bn: 'ঘণ্টা',
    hi: 'घंटे',
    it: 'ore'
  }
};

for (const loc of LOCALES) {
  for (const dir of ['locales', 'assets/locales']) {
    const p = path.join(ROOT, dir, `${loc}.json`);
    const data = JSON.parse(fs.readFileSync(p, 'utf8'));
    for (const [k, v] of Object.entries(hijriAndDurationKeys)) {
      data[k] = v[loc];
    }
    fs.writeFileSync(p, JSON.stringify(data, null, 2) + '\n', 'utf8');
  }
  const arbPath = path.join(ROOT, 'assets/l10n', `app_${loc}.arb`);
  const arb = JSON.parse(fs.readFileSync(arbPath, 'utf8'));
  for (const [k, v] of Object.entries(hijriAndDurationKeys)) {
    arb[k] = v[loc];
    if (loc === 'en') arb[`@${k}`] = { description: `Translation for ${k}` };
  }
  fs.writeFileSync(arbPath, JSON.stringify(arb, null, 2) + '\n', 'utf8');
}

console.log('Added hijri & duration keys across all catalogs.');
