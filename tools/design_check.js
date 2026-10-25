const fs = require('fs');
const path = require('path');
const { runAudit } = require('./scan_design_audit');

const ROOT = path.resolve(__dirname, '..');
const BASELINE_PATH = path.join(ROOT, 'tools', 'design_baseline.json');

function checkDesignBaseline(options = {}) {
  const baselineFile = options.baselinePath || BASELINE_PATH;
  const updateBaseline = options.update || process.argv.includes('--update');
  
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

  const errors = [];
  const improvements = [];
  const currentCounts = {};

  for (const [file, data] of Object.entries(audit.fileCounts)) {
    if (data.total > 0) {
      currentCounts[file] = data.total;
    }
  }

  // 1. Check for regressions or unbaselined new files
  for (const [file, count] of Object.entries(currentCounts)) {
    const baseCount = baseline[file];
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

  // 2. Check for files completely resolved (present in baseline, now 0)
  for (const [file, baseCount] of Object.entries(baseline)) {
    if (!currentCounts[file]) {
      improvements.push(`${file}: -${baseCount} (FULLY RESOLVED, now 0)`);
    }
  }

  if (updateBaseline) {
    fs.writeFileSync(baselineFile, JSON.stringify(currentCounts, null, 2) + '\n', 'utf8');
    console.log(`Updated baseline at ${baselineFile} with ${Object.keys(currentCounts).length} offending files.`);
  }

  return {
    success: errors.length === 0,
    errors,
    improvements,
    currentCounts,
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
    console.log(`✅ All ${Object.keys(result.currentCounts).length} files adhere strictly to never-increase baseline.`);
    console.log(`✅ Total active violations: ${result.grandTotal} (Zero regressions)`);
    console.log('================================================================\n');
  }
}

module.exports = {
  checkDesignBaseline
};
