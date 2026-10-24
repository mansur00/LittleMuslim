const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const TARGET_DIRS = ['lib/data', 'lib/screens/qaida', 'lib/models'];
const ARABIC_PURE = /^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s\d\p{P}\p{S}\u0660-\u0669\u06F0-\u06F9\u00A0]+$/u;
const BN_REGEX = /[\u0980-\u09FF]/;
const HI_REGEX = /[\u0900-\u097F]/;

const findings = [];

function isProse(str) {
  const trimmed = str.trim();
  if (!/[A-Za-z]/.test(trimmed)) return false;
  if (trimmed.startsWith('assets/') || trimmed.startsWith('package:') || trimmed.startsWith('http://') || trimmed.startsWith('https://')) return false;
  if (/^[a-z0-9_]+(\.[a-z0-9_]+)+$/.test(trimmed)) return false; // dot notation key
  if (/^[a-z0-9_]+$/.test(trimmed)) return false; // snake_case
  if (/^[a-z]+[A-Z0-9][a-zA-Z0-9]*$/.test(trimmed)) return false; // camelCase
  if (/^[A-Z0-9_]+$/.test(trimmed)) return false; // CONSTANT_CASE
  if (['en', 'bn', 'hi', 'it', 'ar', 'ar-SA'].includes(trimmed)) return false;
  if (trimmed.endsWith('.mp3') || trimmed.endsWith('.png') || trimmed.endsWith('.svg') || trimmed.endsWith('.json')) return false;

  const words = trimmed.split(/\s+/).filter(w => /[A-Za-z]/.test(w));
  if (words.length >= 2) return true;
  if (words.length === 1) {
    if (/^[A-Z][a-z]+$/.test(words[0])) return true; // Capitalized e.g. 'Mufradat', 'Alif'
    if (/[.!?:;]$/.test(words[0])) return true;
  }
  return false;
}

function scanDir(dir) {
  const fullDir = path.join(ROOT, dir);
  if (!fs.existsSync(fullDir)) return;
  for (const entry of fs.readdirSync(fullDir, {withFileTypes: true})) {
    const full = path.join(fullDir, entry.name);
    const rel = path.relative(ROOT, full);
    if (entry.isDirectory()) {
      scanDir(rel);
    } else if (full.endsWith('.dart')) {
      const content = fs.readFileSync(full, 'utf8');
      const lines = content.split('\n');
      lines.forEach((line, idx) => {
        const trimmed = line.trim();
        if (trimmed.startsWith('//') || trimmed.startsWith('///') || trimmed.startsWith('*') || trimmed.startsWith('/*')) return;
        
        const regex = /'((?:\\.|[^'\\])*)'|"((?:\\.|[^"\\])*)"/g;
        let match;
        while ((match = regex.exec(line)) !== null) {
          const literal = match[1] !== undefined ? match[1] : match[2];
          if (!literal) continue;
          if (ARABIC_PURE.test(literal)) continue;
          
          if (BN_REGEX.test(literal)) {
            findings.push({ file: rel, line: idx + 1, type: 'Bangla Script', literal });
          } else if (HI_REGEX.test(literal)) {
            findings.push({ file: rel, line: idx + 1, type: 'Hindi / Devanagari Script', literal });
          } else if (isProse(literal)) {
            findings.push({ file: rel, line: idx + 1, type: 'English Prose / Term', literal });
          }
        }
      });
    }
  }
}

for (const d of TARGET_DIRS) scanDir(d);

let md = `# Data & Model i18n Audit Report\n\n`;
md += `Generated: ${new Date().toISOString()}\n\n`;
md += `This audit scans \`lib/data/\`, \`lib/screens/qaida/\`, and \`lib/models/\` for any non-pure-Arabic string literals:\n`;
md += `- Bangla script [\\u0980-\\u09FF]\n`;
md += `- Devanagari script [\\u0900-\\u097F]\n`;
md += `- English sentence / description strings & transliterations\n\n`;

md += `## Summary of Violations\n\n`;
md += `| Category | Count |\n`;
md += `|---|---|\n`;

const byType = {};
findings.forEach(f => { byType[f.type] = (byType[f.type] || 0) + 1; });
for (const [t, count] of Object.entries(byType)) {
  md += `| ${t} | ${count} |\n`;
}
md += `| **Total Violations** | **${findings.length}** |\n\n`;

md += `## Detailed Findings by File\n\n`;
md += `| File:Line | Issue Type | Offending Literal |\n`;
md += `|---|---|---|\n`;

findings.forEach(f => {
  const escaped = f.literal.replace(/\|/g, '\\|').replace(/\n/g, ' ');
  md += `| \`${f.file}:${f.line}\` | ${f.type} | \`${escaped}\` |\n`;
});

const outPath = path.join(ROOT, 'docs', 'i18n-audit-data.md');
fs.writeFileSync(outPath, md, 'utf8');
console.log(`Generated ${outPath} with ${findings.length} findings.`);
