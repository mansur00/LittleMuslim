const fs = require('fs');
const path = require('path');

const LIB_DIR = path.resolve(__dirname, '../../lib');

function getAllDartFiles(dir) {
  let files = [];
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files = files.concat(getAllDartFiles(fullPath));
    } else if (entry.name.endsWith('.dart')) {
      files.push(fullPath);
    }
  }
  return files;
}

const files = getAllDartFiles(LIB_DIR);

const buttonAudit = { raw: [], ds: [] };
const inputAudit = { raw: [], ds: [] };
const badgeChipAudit = { raw: [], ds: [] };
const feedbackAudit = { raw: [], ds: [] };
const listTileAudit = { raw: [], ds: [] };
const progressAudit = { raw: [], ds: [] };

for (const filePath of files) {
  const relPath = path.relative(path.resolve(__dirname, '../..'), filePath);
  const isDs = relPath.startsWith('lib/widgets/ds/');
  const content = fs.readFileSync(filePath, 'utf8');
  const lines = content.split('\n');

  lines.forEach((line, idx) => {
    const lineNum = idx + 1;
    const loc = `${relPath}:${lineNum}`;

    // 1. Buttons
    if (!isDs) {
      const rawBtnMatch = line.match(/\b(ElevatedButton|TextButton|OutlinedButton|FilledButton|IconButton|DuolingoButton|Duolingo3DButton|DSButton)\b/);
      if (rawBtnMatch) {
        buttonAudit.raw.push({ component: rawBtnMatch[1], loc, snippet: line.trim() });
      }
      // Gesture/InkWell styled as button
      if (line.match(/\b(InkWell|GestureDetector)\b/) && (content.includes('borderRadius') || content.includes('BoxDecoration'))) {
        // Look ahead 5 lines for Container with decoration
        const nextLines = lines.slice(idx, idx + 5).join(' ');
        if (nextLines.includes('Container') && (nextLines.includes('decoration:') || nextLines.includes('color:'))) {
          buttonAudit.raw.push({ component: 'Custom GestureDetector/InkWell Button', loc, snippet: line.trim() });
        }
      }
    }
    if (line.match(/\bAppButton\b/)) {
      buttonAudit.ds.push({ component: 'AppButton', loc, snippet: line.trim() });
    }

    // 2. Inputs
    if (!isDs) {
      const inputMatch = line.match(/\b(TextField|TextFormField|DropdownButton|DropdownButtonFormField|Switch|SwitchListTile|CupertinoSwitch|Checkbox|CheckboxListTile|Radio|RadioListTile|Slider)\b/);
      if (inputMatch) {
        inputAudit.raw.push({ component: inputMatch[1], loc, snippet: line.trim() });
      }
    }
    // Check DS input equivalents
    if (line.match(/\b(AppTextField|AppSwitch|AppCheckbox|AppSlider|AppSelect|AppSwitchTile)\b/)) {
      inputAudit.ds.push({ component: line.match(/\b(AppTextField|AppSwitch|AppCheckbox|AppSlider|AppSelect|AppSwitchTile)\b/)[1], loc, snippet: line.trim() });
    }

    // 3. Badges / Chips
    if (!isDs) {
      const chipMatch = line.match(/\b(Chip|RawChip|InputChip|ChoiceChip|FilterChip|ActionChip|Badge)\b/);
      if (chipMatch) {
        badgeChipAudit.raw.push({ component: chipMatch[1], loc, snippet: line.trim() });
      }
      if (line.includes('_CategoryPill') || line.includes('DuolingoCategoryBar')) {
        badgeChipAudit.raw.push({ component: 'Legacy _CategoryPill', loc, snippet: line.trim() });
      }
    }
    if (line.match(/\b(AppBadge|AppChip)\b/)) {
      badgeChipAudit.ds.push({ component: line.match(/\b(AppBadge|AppChip)\b/)[1], loc, snippet: line.trim() });
    }

    // 4. Dialogs / Sheets / Feedback
    if (!isDs) {
      const feedbackMatch = line.match(/\b(showDialog|AlertDialog|showModalBottomSheet|SnackBar|ScaffoldMessenger)\b/);
      if (feedbackMatch) {
        feedbackAudit.raw.push({ component: feedbackMatch[1], loc, snippet: line.trim() });
      }
    }
    if (line.match(/\b(AppDialog|AppBottomSheet)\b/)) {
      feedbackAudit.ds.push({ component: line.match(/\b(AppDialog|AppBottomSheet)\b/)[1], loc, snippet: line.trim() });
    }

    // 5. Lists / Tiles
    if (!isDs) {
      const tileMatch = line.match(/\b(ListTile)\b/);
      if (tileMatch) {
        listTileAudit.raw.push({ component: tileMatch[1], loc, snippet: line.trim() });
      }
    }
    if (line.match(/\b(AppListTile)\b/)) {
      listTileAudit.ds.push({ component: 'AppListTile', loc, snippet: line.trim() });
    }

    // 6. Progress
    if (!isDs) {
      const progressMatch = line.match(/\b(LinearProgressIndicator|CircularProgressIndicator)\b/);
      if (progressMatch) {
        progressAudit.raw.push({ component: progressMatch[1], loc, snippet: line.trim() });
      }
    }
    if (line.match(/\b(AppProgressBar)\b/)) {
      progressAudit.ds.push({ component: 'AppProgressBar', loc, snippet: line.trim() });
    }
  });
}

function summarize(categoryName, audit) {
  console.log(`\n=================== ${categoryName} ===================`);
  console.log(`Total Raw usages (outside lib/widgets/ds): ${audit.raw.length}`);
  console.log(`Total DS usages: ${audit.ds.length}`);
  
  const rawByType = {};
  audit.raw.forEach(r => {
    rawByType[r.component] = (rawByType[r.component] || 0) + 1;
  });
  console.log('Raw Breakdown:');
  console.table(Object.entries(rawByType).map(([component, count]) => ({ component, count })));
  
  console.log('Raw Usages (file:line):');
  console.table(audit.raw.map(r => ({ component: r.component, loc: r.loc, snippet: r.snippet.slice(0, 60) })));
}

summarize('1. BUTTONS', buttonAudit);
summarize('2. INPUTS', inputAudit);
summarize('3. BADGES & CHIPS', badgeChipAudit);
summarize('4. DIALOGS, SHEETS & SNACKBARS', feedbackAudit);
summarize('5. LIST TILES', listTileAudit);
summarize('6. PROGRESS INDICATORS', progressAudit);
