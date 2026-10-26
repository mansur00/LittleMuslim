const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');

const newKeys = {
  en: {
    "admin.parental_gate_title": "Parental Gate",
    "admin.parental_gate_prompt": "Ask your parent to solve this challenge to enter Admin Mode.",
    "admin.parental_gate_question": "What is {num1} + {num2}?",
    "admin.parental_gate_hint": "Enter answer",
    "admin.parental_gate_error": "Incorrect answer. Please try again.",
    "admin.parental_gate_confirm": "Confirm",
    "admin.parental_gate_cancel": "Cancel",
    "admin.parental_gate_lockout": "Too many attempts. Try again in {seconds}s"
  },
  bn: {
    "admin.parental_gate_title": "অভিভাবক যাচাই",
    "admin.parental_gate_prompt": "অ্যাডমিন মোডে প্রবেশ করতে এই গণিত সমাধান করতে আপনার অভিভাবককে বলুন।",
    "admin.parental_gate_question": "{num1} + {num2} = কত?",
    "admin.parental_gate_hint": "উত্তর লিখুন",
    "admin.parental_gate_error": "ভুল উত্তর। আবার চেষ্টা করুন।",
    "admin.parental_gate_confirm": "নিশ্চিত করুন",
    "admin.parental_gate_cancel": "বাতিল",
    "admin.parental_gate_lockout": "অতিরিক্ত ভুল প্রচেষ্টা। {seconds} সেকেন্ড পর আবার চেষ্টা করুন"
  },
  hi: {
    "admin.parental_gate_title": "अभिभावक सत्यापन",
    "admin.parental_gate_prompt": "एडमिन मोड में प्रवेश करने के लिए अपने अभिभावक से इस प्रश्न को हल करवाएं।",
    "admin.parental_gate_question": "{num1} + {num2} कितना होता है?",
    "admin.parental_gate_hint": "उत्तर दर्ज करें",
    "admin.parental_gate_error": "गलत उत्तर। कृपया पुनः प्रयास करें।",
    "admin.parental_gate_confirm": "पुष्टि करें",
    "admin.parental_gate_cancel": "रद्द करें",
    "admin.parental_gate_lockout": "बहुत अधिक गलत प्रयास। {seconds} सेकंड बाद पुनः प्रयास करें"
  },
  it: {
    "admin.parental_gate_title": "Controllo genitori",
    "admin.parental_gate_prompt": "Chiedi ai tuoi genitori di risolvere questo calcolo per entrare in Modalità Amministratore.",
    "admin.parental_gate_question": "Quanto fa {num1} + {num2}?",
    "admin.parental_gate_hint": "Inserisci la risposta",
    "admin.parental_gate_error": "Risposta errata. Riprova.",
    "admin.parental_gate_confirm": "Conferma",
    "admin.parental_gate_cancel": "Annulla",
    "admin.parental_gate_lockout": "Troppi tentativi. Riprova tra {seconds}s"
  }
};

const locales = ['en', 'bn', 'hi', 'it'];

// 1. Update locales/*.json and assets/locales/*.json
for (const loc of locales) {
  for (const dir of ['locales', 'assets/locales']) {
    const filePath = path.join(root, dir, `${loc}.json`);
    const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    for (const [k, v] of Object.entries(newKeys[loc])) {
      data[k] = v;
    }
    fs.writeFileSync(filePath, JSON.stringify(data, null, 2) + '\n', 'utf8');
    console.log(`Updated ${dir}/${loc}.json`);
  }
}

// 2. Update assets/l10n/app_*.arb
for (const loc of locales) {
  const filePath = path.join(root, 'assets', 'l10n', `app_${loc}.arb`);
  const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  for (const [k, v] of Object.entries(newKeys[loc])) {
    data[k] = v;
    data[`@${k}`] = {
      description: `Parental gate: ${k}`
    };
  }
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2) + '\n', 'utf8');
  console.log(`Updated assets/l10n/app_${loc}.arb`);
}

// 3. Regenerate lib/l10n/static_translations.dart
const enData = JSON.parse(fs.readFileSync(path.join(root, 'locales', 'en.json'), 'utf8'));
const bnData = JSON.parse(fs.readFileSync(path.join(root, 'locales', 'bn.json'), 'utf8'));
const hiData = JSON.parse(fs.readFileSync(path.join(root, 'locales', 'hi.json'), 'utf8'));
const itData = JSON.parse(fs.readFileSync(path.join(root, 'locales', 'it.json'), 'utf8'));

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

class StaticTranslations {
  static Map<String, String> get en => staticTranslations['en'] ?? {};
  static Map<String, String> get bn => staticTranslations['bn'] ?? {};
  static Map<String, String> get hi => staticTranslations['hi'] ?? {};
  static Map<String, String> get it => staticTranslations['it'] ?? {};

  static Map<String, String> get(String code) => staticTranslations[code] ?? en;

  static String? lookup(String key, {String locale = 'en', Map<String, dynamic>? params}) {
    final dict = get(locale);
    var val = dict[key] ?? en[key];
    if (val == null) return null;
    if (params != null && params.isNotEmpty) {
      params.forEach((paramKey, paramVal) {
        val = val!.replaceAll('{{' + paramKey + '}}', paramVal.toString());
        val = val!.replaceAll('{' + paramKey + '}', paramVal.toString());
      });
    }
    return val;
  }
}
`;

fs.writeFileSync(path.join(root, 'lib', 'l10n', 'static_translations.dart'), dartContent, 'utf8');
console.log('static_translations.dart written successfully.');
