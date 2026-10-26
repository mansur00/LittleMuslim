#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');

const SECRET_PATTERNS = [
  { name: 'Figma Personal Access Token', regex: /\bfigd_[A-Za-z0-9_-]{10,}\b/i },
  { name: 'Generic Figma Token Prefix', regex: /['"][A-Za-z0-9_-]*figd_[A-Za-z0-9_-]+['"]/i },
  { name: 'Google API Key', regex: /\bAIza[0-9A-Za-z-_]{35}\b/ },
  { name: 'AWS Access Key ID', regex: /\b(AKIA|ABIA|ACCA|ASIA)[0-9A-Z]{16}\b/ },
  { name: 'GitHub Personal Access Token', regex: /\b(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9_]{36,}\b/ },
  { name: 'Private Key Block', regex: /-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----/ },
  { name: 'Generic Secret Assignment', regex: /(api[_-]?key|access[_-]?token|secret[_-]?key)\s*[:=]\s*['"][A-Za-z0-9_/-]{24,}['"]/i }
];

const IGNORE_DIRS = new Set([
  '.git',
  '.dart_tool',
  'build',
  'node_modules',
  '.gradle',
  '.idea',
  'scratch'
]);

function getStagedOrAllFiles() {
  const args = process.argv.slice(2);
  if (args.includes('--all')) {
    const results = [];
    function walk(dir) {
      for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
        if (IGNORE_DIRS.has(entry.name)) continue;
        const full = path.join(dir, entry.name);
        if (entry.isDirectory()) {
          walk(full);
        } else if (entry.isFile()) {
          results.push(path.relative(ROOT, full));
        }
      }
    }
    walk(ROOT);
    return results;
  }

  try {
    const staged = execSync('git diff --cached --name-only --diff-filter=ACM', {
      cwd: ROOT,
      encoding: 'utf8'
    }).trim();
    if (staged) {
      return staged.split('\n').map(s => s.trim()).filter(Boolean);
    }
  } catch (_) {}

  // Fallback if not staged: check git diff against HEAD
  try {
    const diff = execSync('git diff --name-only --diff-filter=ACM', {
      cwd: ROOT,
      encoding: 'utf8'
    }).trim();
    if (diff) {
      return diff.split('\n').map(s => s.trim()).filter(Boolean);
    }
  } catch (_) {}

  return [];
}

function scanFiles(fileList) {
  const violations = [];

  for (const relPath of fileList) {
    if (relPath === 'tools/secret_scan.js' || relPath === 'test/secret_scan_test.js') {
      continue; // Skip the scanner itself and its self-test fixture
    }

    const fullPath = path.join(ROOT, relPath);
    if (!fs.existsSync(fullPath)) continue;

    // Skip binary files and images
    const ext = path.extname(relPath).toLowerCase();
    if (['.png', '.jpg', '.jpeg', '.gif', '.ico', '.webp', '.woff', '.woff2', '.ttf', '.otf', '.zip', '.pdf'].includes(ext)) {
      continue;
    }

    let content;
    try {
      content = fs.readFileSync(fullPath, 'utf8');
    } catch (_) {
      continue;
    }

    const lines = content.split('\n');
    lines.forEach((line, idx) => {
      const lineNum = idx + 1;
      for (const pattern of SECRET_PATTERNS) {
        if (pattern.regex.test(line)) {
          violations.push({
            file: relPath,
            line: lineNum,
            pattern: pattern.name,
            snippet: line.trim().slice(0, 80)
          });
        }
      }
    });
  }

  return violations;
}

function main() {
  const files = getStagedOrAllFiles();
  if (files.length === 0) {
    console.log('✅ Secret scanner: No files to scan.');
    process.exit(0);
  }

  const violations = scanFiles(files);
  if (violations.length > 0) {
    console.error('================================================================');
    console.error(' ❌ CRITICAL SECURITY ERROR: SECRETS DETECTED IN CODEBASE');
    console.error('================================================================');
    violations.forEach(v => {
      console.error(`  [${v.pattern}] ${v.file}:${v.line}`);
      console.error(`    -> ${v.snippet.replace(/figd_[A-Za-z0-9_-]+/g, 'figd_***REDACTED***')}`);
    });
    console.error('================================================================');
    console.error('Never commit tokens, passwords, or API keys.');
    console.error('Use environment variables (e.g. FIGMA_ACCESS_TOKEN) instead.');
    process.exit(1);
  }

  console.log(`✅ Secret scan passed: ${files.length} file(s) checked, 0 secrets detected.`);
  process.exit(0);
}

if (require.main === module) {
  main();
}

module.exports = { SECRET_PATTERNS, scanFiles };
