const fs = require('fs');
const path = require('path');
const assert = require('assert');
const { runAudit } = require('../tools/scan_design_audit');
const { checkDesignBaseline } = require('../tools/design_check');

const ROOT = path.resolve(__dirname, '..');
const FIXTURES_DIR = path.join(ROOT, 'tools', '__fixtures__', 'design');

console.log('================================================================');
console.log('         DESIGN SYSTEM CHECKER COMPREHENSIVE SELF-TEST          ');
console.log('================================================================\n');

let passedTests = 0;
let totalTests = 0;

function test(name, fn) {
  totalTests++;
  try {
    fn();
    console.log(`✅ [PASS] ${name}`);
    passedTests++;
  } catch (err) {
    console.error(`❌ [FAIL] ${name}`);
    console.error(`   Error: ${err.message}`);
  }
}

// 1. Fixture Tests
test('Good fixture (good_clean.dart) has ZERO violations', () => {
  const goodFile = path.join(FIXTURES_DIR, 'good_clean.dart');
  const audit = runAudit({ files: [goodFile] });
  assert.strictEqual(audit.grandTotal, 0, `Expected 0 violations, found ${audit.grandTotal}`);
});

test('Bad fixture (bad_hardcoded_color.dart) detects Hardcoded Color', () => {
  const badFile = path.join(FIXTURES_DIR, 'bad_hardcoded_color.dart');
  const audit = runAudit({ files: [badFile] });
  assert.ok(audit.categories.colors.count >= 1, 'Expected colors violation');
});

test('Bad fixture (bad_hardcoded_text_style.dart) detects Hardcoded Text Style', () => {
  const badFile = path.join(FIXTURES_DIR, 'bad_hardcoded_text_style.dart');
  const audit = runAudit({ files: [badFile] });
  assert.ok(audit.categories.textStyles.count >= 1, 'Expected text style violation');
});

test('Bad fixture (bad_hardcoded_spacing.dart) detects Hardcoded Spacing', () => {
  const badFile = path.join(FIXTURES_DIR, 'bad_hardcoded_spacing.dart');
  const audit = runAudit({ files: [badFile] });
  assert.ok(audit.categories.spacing.count >= 1, 'Expected spacing violation');
});

// 2. Baseline Gate Regression Tests
test('Gate FAILS when a file violation count exceeds baseline', () => {
  const mockFile = 'lib/screens/sample.dart';
  const baselinePath = path.join(ROOT, 'tools', '__fixtures__', 'mock_baseline.json');
  fs.writeFileSync(baselinePath, JSON.stringify({ [mockFile]: 5 }, null, 2), 'utf8');

  try {
    const mockAudit = {
      grandTotal: 10,
      fileCounts: { [mockFile]: { total: 10 } }
    };
    const res = checkDesignBaseline({ baselinePath, auditResult: mockAudit });
    assert.strictEqual(res.success, false, 'Expected check to fail');
    assert.ok(res.errors.some(e => e.includes('[REGRESSION]')), 'Expected regression error');
  } finally {
    if (fs.existsSync(baselinePath)) fs.unlinkSync(baselinePath);
  }
});

test('Gate FAILS when an unbaselined file introduces violations', () => {
  const baselinePath = path.join(ROOT, 'tools', '__fixtures__', 'mock_baseline.json');
  fs.writeFileSync(baselinePath, JSON.stringify({ 'lib/screens/old.dart': 2 }, null, 2), 'utf8');

  try {
    const mockAudit = {
      grandTotal: 5,
      fileCounts: {
        'lib/screens/old.dart': { total: 2 },
        'lib/screens/new_unbaselined.dart': { total: 3 }
      }
    };
    const res = checkDesignBaseline({ baselinePath, auditResult: mockAudit });
    assert.strictEqual(res.success, false, 'Expected check to fail on unbaselined file');
    assert.ok(res.errors.some(e => e.includes('[NEW FILE WITH VIOLATIONS]')), 'Expected new file error');
  } finally {
    if (fs.existsSync(baselinePath)) fs.unlinkSync(baselinePath);
  }
});

test('Gate PASSES when violation counts stay equal or improve', () => {
  const baselinePath = path.join(ROOT, 'tools', '__fixtures__', 'mock_baseline.json');
  fs.writeFileSync(baselinePath, JSON.stringify({ 'lib/screens/sample.dart': 10 }, null, 2), 'utf8');

  try {
    const mockAudit = {
      grandTotal: 8,
      fileCounts: {
        'lib/screens/sample.dart': { total: 8 } // Improved by -2
      }
    };
    const res = checkDesignBaseline({ baselinePath, auditResult: mockAudit });
    assert.strictEqual(res.success, true, 'Expected check to pass on improvement');
    assert.strictEqual(res.errors.length, 0);
    assert.ok(res.improvements.length >= 1, 'Expected improvement to be noted');
  } finally {
    if (fs.existsSync(baselinePath)) fs.unlinkSync(baselinePath);
  }
});

test('Gate PASSES on real repository against tools/design_baseline.json', () => {
  const res = checkDesignBaseline();
  assert.strictEqual(res.success, true, 'Real repository must pass baseline check');
  assert.strictEqual(res.errors.length, 0);
});

console.log(`\nResults: ${passedTests}/${totalTests} self-tests passed.`);
if (passedTests !== totalTests) {
  process.exit(1);
}
