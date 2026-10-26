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
  const banned = audit.bannedRuleCounts[goodFile] || audit.fileCounts[goodFile]?.bannedRules;
  assert.strictEqual(banned?.total || 0, 0, 'Expected 0 banned rules');
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

test('Bad fixture (bad_banned_widgets.dart) detects raw ElevatedButton, TextField, Switch, Chip, SnackBar, AlertDialog', () => {
  const badFile = path.join(FIXTURES_DIR, 'bad_banned_widgets.dart');
  const audit = runAudit({ files: [badFile] });
  const banned = Object.values(audit.bannedRuleCounts)[0];
  assert.ok((banned?.bannedWidgets || 0) >= 6, `Expected at least 6 banned widgets, found ${banned?.bannedWidgets}`);
});

test('Bad fixture (bad_shadow_elevation.dart) detects BoxShadow and elevation > 0', () => {
  const badFile = path.join(FIXTURES_DIR, 'bad_shadow_elevation.dart');
  const audit = runAudit({ files: [badFile] });
  const banned = Object.values(audit.bannedRuleCounts)[0];
  assert.ok((banned?.shadowElevation || 0) >= 2, `Expected at least 2 shadow/elevation violations, found ${banned?.shadowElevation}`);
});

test('Bad fixture (bad_gradient_non_mascot.dart) detects gradient outside mascot allowlist', () => {
  const badFile = path.join(FIXTURES_DIR, 'bad_gradient_non_mascot.dart');
  const audit = runAudit({ files: [badFile] });
  const banned = Object.values(audit.bannedRuleCounts)[0];
  assert.ok((banned?.gradient || 0) >= 1, `Expected gradient violation, found ${banned?.gradient}`);
});

test('Bad fixture (bad_card_border.dart) detects Card border strokes', () => {
  const badFile = path.join(FIXTURES_DIR, 'bad_card_border.dart');
  const audit = runAudit({ files: [badFile] });
  const banned = Object.values(audit.bannedRuleCounts)[0];
  assert.ok((banned?.cardBorder || 0) >= 1, `Expected card border violation, found ${banned?.cardBorder}`);
});

test('Mascot allowlist allows gradients in vector_mascot.dart', () => {
  const mascotFile = path.join(ROOT, 'lib', 'widgets', 'vector_mascot.dart');
  const audit = runAudit({ files: [mascotFile] });
  const banned = Object.values(audit.bannedRuleCounts)[0];
  assert.strictEqual(banned?.gradient || 0, 0, `Expected 0 gradient violations in mascot, found ${banned?.gradient}`);
});

// 2. Baseline Gate Regression Tests
test('Gate FAILS when a file legacy violation count exceeds baseline', () => {
  const mockFile = 'lib/screens/sample.dart';
  const baselinePath = path.join(ROOT, 'tools', '__fixtures__', 'mock_baseline.json');
  fs.writeFileSync(baselinePath, JSON.stringify({ [mockFile]: 5 }, null, 2), 'utf8');

  try {
    const mockAudit = {
      grandTotal: 10,
      fileCounts: { [mockFile]: { total: 10 } },
      bannedRuleCounts: {}
    };
    const res = checkDesignBaseline({ baselinePath, auditResult: mockAudit });
    assert.strictEqual(res.success, false, 'Expected check to fail');
    assert.ok(res.errors.some(e => e.includes('[REGRESSION]')), 'Expected regression error');
  } finally {
    if (fs.existsSync(baselinePath)) fs.unlinkSync(baselinePath);
  }
});

test('Gate FAILS when a file banned rules count exceeds bannedRulesBaseline', () => {
  const mockFile = 'lib/screens/sample.dart';
  const baselinePath = path.join(ROOT, 'tools', '__fixtures__', 'mock_baseline.json');
  fs.writeFileSync(baselinePath, JSON.stringify({
    [mockFile]: 5,
    bannedRulesBaseline: {
      [mockFile]: { bannedWidgets: 1, shadowElevation: 0, gradient: 0, cardBorder: 0, total: 1 }
    }
  }, null, 2), 'utf8');

  try {
    const mockAudit = {
      grandTotal: 5,
      fileCounts: { [mockFile]: { total: 5 } },
      bannedRuleCounts: {
        [mockFile]: { bannedWidgets: 3, shadowElevation: 0, gradient: 0, cardBorder: 0, total: 3 }
      }
    };
    const res = checkDesignBaseline({ baselinePath, auditResult: mockAudit });
    assert.strictEqual(res.success, false, 'Expected check to fail on banned rule increase');
    assert.ok(res.errors.some(e => e.includes('[BANNED RULE REGRESSION]')), 'Expected banned rule regression error');
  } finally {
    if (fs.existsSync(baselinePath)) fs.unlinkSync(baselinePath);
  }
});

test('Gate FAILS when an unbaselined file introduces banned rules', () => {
  const baselinePath = path.join(ROOT, 'tools', '__fixtures__', 'mock_baseline.json');
  fs.writeFileSync(baselinePath, JSON.stringify({
    'lib/screens/old.dart': 2,
    bannedRulesBaseline: {
      'lib/screens/old.dart': { bannedWidgets: 0, shadowElevation: 0, gradient: 0, cardBorder: 0, total: 0 }
    }
  }, null, 2), 'utf8');

  try {
    const mockAudit = {
      grandTotal: 2,
      fileCounts: {
        'lib/screens/old.dart': { total: 2 },
        'lib/screens/new.dart': { total: 0 }
      },
      bannedRuleCounts: {
        'lib/screens/new.dart': { bannedWidgets: 1, shadowElevation: 0, gradient: 0, cardBorder: 0, total: 1 }
      }
    };
    const res = checkDesignBaseline({ baselinePath, auditResult: mockAudit });
    assert.strictEqual(res.success, false, 'Expected check to fail on unbaselined banned rule file');
    assert.ok(res.errors.some(e => e.includes('[NEW FILE WITH BANNED RULES]')), 'Expected new file error');
  } finally {
    if (fs.existsSync(baselinePath)) fs.unlinkSync(baselinePath);
  }
});

test('Gate PASSES when violation counts stay equal or improve', () => {
  const baselinePath = path.join(ROOT, 'tools', '__fixtures__', 'mock_baseline.json');
  fs.writeFileSync(baselinePath, JSON.stringify({
    'lib/screens/sample.dart': 10,
    bannedRulesBaseline: {
      'lib/screens/sample.dart': { bannedWidgets: 2, shadowElevation: 0, gradient: 0, cardBorder: 0, total: 2 }
    }
  }, null, 2), 'utf8');

  try {
    const mockAudit = {
      grandTotal: 8,
      fileCounts: {
        'lib/screens/sample.dart': { total: 8 } // Improved by -2
      },
      bannedRuleCounts: {
        'lib/screens/sample.dart': { bannedWidgets: 1, shadowElevation: 0, gradient: 0, cardBorder: 0, total: 1 } // Improved by -1
      }
    };
    const res = checkDesignBaseline({ baselinePath, auditResult: mockAudit });
    assert.strictEqual(res.success, true, 'Expected check to pass on improvement');
    assert.strictEqual(res.errors.length, 0);
    assert.ok(res.improvements.length >= 2, 'Expected improvements in both legacy and banned sections');
  } finally {
    if (fs.existsSync(baselinePath)) fs.unlinkSync(baselinePath);
  }
});

test('Gate PASSES on real repository against tools/design_baseline.json', () => {
  const res = checkDesignBaseline();
  assert.strictEqual(res.success, true, `Real repository must pass baseline check. Errors: ${res.errors.join(', ')}`);
  assert.strictEqual(res.errors.length, 0);
});

console.log(`\nResults: ${passedTests}/${totalTests} self-tests passed.`);
if (passedTests !== totalTests) {
  process.exit(1);
}
