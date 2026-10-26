const fs = require('fs');
const path = require('path');
const { runAudit } = require('./scan_design_audit');

const ROOT = path.resolve(__dirname, '..');
const BASELINE_PATH = path.join(ROOT, 'tools', 'design_baseline.json');

function checkDesignBaseline(options = {}) {
  const baselineFile = options.baselinePath || BASELINE_PATH;
  
  if (!fs.existsSync(baselineFile)) {
    console.error(`ERROR: Baseline file not found at ${baselineFile}`);
    return { success: false, errors: [`Baseline file missing: ${baselineFile}`] };
  }

  const baseline = JSON.parse(fs.readFileSync(baselineFile, 'utf8'));
  const audit = options.auditResult || runAudit({
    root: options.root || ROOT,
    libDir: options.libDir,
    files: options.files
  });

  const legacyBaseline = { ...baseline };
  delete legacyBaseline.bannedRulesBaseline;
  const bannedRulesBaseline = baseline.bannedRulesBaseline || {};

  const errors = [];
  const improvements = [];
  const currentCounts = {};

  for (const [file, data] of Object.entries(audit.fileCounts)) {
    if (data.total > 0) {
      currentCounts[file] = data.total;
    }
  }

  // 1. Check for legacy regressions or unbaselined new files
  for (const [file, count] of Object.entries(currentCounts)) {
    const baseCount = legacyBaseline[file];
    if (baseCount === undefined) {
      errors.push(`[NEW FILE WITH VIOLATIONS] ${file} has ${count} design system violations but is not recorded in baseline.`);
    } else if (count > baseCount) {
      const diff = count - baseCount;
      errors.push(`[REGRESSION] ${file} violations increased by +${diff} (was ${baseCount}, now ${count}).`);
    } else if (count < baseCount) {
      const diff = baseCount - count;
      improvements.push(`${file}: -${diff} (was ${baseCount}, now ${count})`);
    }
  }

  // 2. Check for legacy files completely resolved
  for (const [file, baseCount] of Object.entries(legacyBaseline)) {
    if (!currentCounts[file]) {
      improvements.push(`${file}: -${baseCount} (FULLY RESOLVED, now 0)`);
    }
  }

  // 3. Check separate bannedRulesBaseline (bannedWidgets, shadowElevation, gradient, cardBorder)
  const currentBanned = audit.bannedRuleCounts || {};
  for (const [file, counts] of Object.entries(currentBanned)) {
    if (counts.total === 0) continue;
    const baseEntry = bannedRulesBaseline[file];
    if (!baseEntry) {
      errors.push(`[NEW FILE WITH BANNED RULES] ${file} has ${counts.total} banned design rules (widgets: ${counts.bannedWidgets}, shadow/elevation: ${counts.shadowElevation}, gradients: ${counts.gradient}, cardBorders: ${counts.cardBorder}) but is not in bannedRulesBaseline.`);
    } else {
      if (counts.bannedWidgets > baseEntry.bannedWidgets) {
        errors.push(`[BANNED RULE REGRESSION] ${file} bannedWidgets increased by +${counts.bannedWidgets - baseEntry.bannedWidgets} (was ${baseEntry.bannedWidgets}, now ${counts.bannedWidgets}).`);
      }
      if (counts.shadowElevation > baseEntry.shadowElevation) {
        errors.push(`[BANNED RULE REGRESSION] ${file} shadowElevation increased by +${counts.shadowElevation - baseEntry.shadowElevation} (was ${baseEntry.shadowElevation}, now ${counts.shadowElevation}).`);
      }
      if (counts.gradient > baseEntry.gradient) {
        errors.push(`[BANNED RULE REGRESSION] ${file} gradients outside mascot increased by +${counts.gradient - baseEntry.gradient} (was ${baseEntry.gradient}, now ${counts.gradient}).`);
      }
      if (counts.cardBorder > baseEntry.cardBorder) {
        errors.push(`[BANNED RULE REGRESSION] ${file} cardBorder increased by +${counts.cardBorder - baseEntry.cardBorder} (was ${baseEntry.cardBorder}, now ${counts.cardBorder}).`);
      }
      if (counts.total < baseEntry.total) {
        improvements.push(`${file} (banned rules): -${baseEntry.total - counts.total} (was ${baseEntry.total}, now ${counts.total})`);
      }
    }
  }

  for (const [file, baseEntry] of Object.entries(bannedRulesBaseline)) {
    if (!currentBanned[file] || currentBanned[file].total === 0) {
      improvements.push(`${file} (banned rules): FULLY RESOLVED, now 0 (was ${baseEntry.total})`);
    }
  }

  return {
    success: errors.length === 0,
    errors,
    improvements,
    currentCounts,
    currentBanned,
    grandTotal: audit.grandTotal
  };
}

if (require.main === module) {
  console.log('================================================================');
  console.log('        LITTLE MUSLIM DESIGN SYSTEM NEVER-INCREASE GATE         ');
  console.log('================================================================\n');

  const result = checkDesignBaseline();

  if (result.improvements.length > 0) {
    console.log('--- PROGRESS & IMPROVEMENTS ---');
    result.improvements.forEach(imp => console.log(`  🎉 ${imp}`));
    console.log('');
  }

  if (!result.success) {
    console.error('--- DESIGN SYSTEM VIOLATIONS (REGRESSION DETECTED) ---');
    result.errors.forEach(err => console.error(`  ❌ ${err}`));
    console.error(`\nFAILED: Found ${result.errors.length} regression(s). Total violations: ${result.grandTotal}`);
    console.error('Violations must NEVER increase. Use DS tokens in lib/theme/ and lib/widgets/ds/.\n');
    process.exit(1);
  } else {
    console.log(`✅ All ${Object.keys(result.currentCounts).length} files adhere strictly to legacy baseline (${result.grandTotal} legacy violations).`);
    console.log(`✅ All ${Object.keys(result.currentBanned).length} files adhere strictly to banned rules baseline (Zero regressions).`);
    console.log('================================================================\n');
  }
}

module.exports = {
  checkDesignBaseline
};
