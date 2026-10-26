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

const touchTargets = {
  under24: [],
  under44: []
};

const semanticsAudit = {
  unlabeledButtons: [],
  unlabeledImages: [],
  unlabeledFields: [],
  colorOnlyStatus: [],
  animationsWithoutReduceMotion: [],
  headingsWithoutSemantics: []
};

for (const filePath of files) {
  const relPath = path.relative(path.resolve(__dirname, '../..'), filePath);
  const content = fs.readFileSync(filePath, 'utf8');
  const lines = content.split('\n');

  lines.forEach((line, idx) => {
    const lineNum = idx + 1;
    const loc = `${relPath}:${lineNum}`;

    // 1. Touch targets (explicit width/height on InkWell/GestureDetector/IconButton/Container tappables)
    // Check for width: < 44 or height: < 44 on buttons/interactive elements
    if (line.match(/\b(IconButton|InkWell|GestureDetector)\b/) || (line.includes('onTap') && line.includes('Container'))) {
      const window = lines.slice(Math.max(0, idx - 4), Math.min(lines.length, idx + 8)).join(' ');
      const sizeMatch = window.match(/(?:width|height|size):\s*([0-9.]+)/);
      if (sizeMatch) {
        const dim = parseFloat(sizeMatch[1]);
        if (dim < 24) {
          touchTargets.under24.push({ loc, size: dim, snippet: line.trim() });
        } else if (dim < 44) {
          touchTargets.under44.push({ loc, size: dim, snippet: line.trim() });
        }
      }
    }
    // Also check icon button sizes or padding
    if (line.includes('IconButton(') && !line.includes('iconSize: 44')) {
      const window = lines.slice(idx, Math.min(lines.length, idx + 5)).join(' ');
      const iconSize = window.match(/iconSize:\s*([0-9.]+)/);
      if (iconSize && parseFloat(iconSize[1]) < 24) {
        touchTargets.under24.push({ loc, size: parseFloat(iconSize[1]), snippet: line.trim() });
      }
    }

    // 2. Unlabeled Icon Buttons
    if (line.match(/\bIconButton\s*\(/)) {
      const window = lines.slice(idx, Math.min(lines.length, idx + 6)).join(' ');
      if (!window.includes('tooltip:') && !window.includes('Semantics')) {
        semanticsAudit.unlabeledButtons.push({ loc, snippet: line.trim() });
      }
    }

    // 3. Unlabeled Images / SVG / Icons
    if (line.match(/\bImage\.asset\s*\(/) || line.match(/\bSvgPicture\.asset\s*\(/)) {
      const window = lines.slice(idx, Math.min(lines.length, idx + 6)).join(' ');
      if (!window.includes('semanticLabel') && !window.includes('excludeFromSemantics')) {
        semanticsAudit.unlabeledImages.push({ loc, snippet: line.trim() });
      }
    }

    // 4. TextFields without labels
    if (line.match(/\b(TextField|TextFormField)\s*\(/)) {
      const window = lines.slice(idx, Math.min(lines.length, idx + 10)).join(' ');
      if (!window.includes('labelText') && !window.includes('hintText') && !window.includes('Semantics')) {
        semanticsAudit.unlabeledFields.push({ loc, snippet: line.trim() });
      }
    }

    // 5. Animations without reduce motion handling
    if (line.match(/\bAnimationController\s*\(/)) {
      const window = lines.slice(Math.max(0, idx - 10), Math.min(lines.length, idx + 15)).join(' ');
      if (!window.includes('disableAnimations') && !window.includes('accessibleNavigation') && !window.includes('prefers-reduced-motion')) {
        semanticsAudit.animationsWithoutReduceMotion.push({ loc, snippet: line.trim() });
      }
    }

    // 6. Color-alone status indicators (e.g. dot or container indicating active/done by color without text)
    if (line.includes('BoxShape.circle') && (line.includes('isCompleted') || line.includes('isActive') || line.includes('isUnlocked') || line.includes('isPlaying'))) {
      const window = lines.slice(idx, Math.min(lines.length, idx + 6)).join(' ');
      if (!window.includes('Semantics') && !window.includes('Icon') && !window.includes('Text')) {
        semanticsAudit.colorOnlyStatus.push({ loc, snippet: line.trim() });
      }
    }
  });
}

console.log('=== TOUCH TARGET AUDIT ===');
console.log(`Tappables < 24x24 (WCAG 2.5.8 AA Failure): ${touchTargets.under24.length}`);
console.table(touchTargets.under24);

console.log(`\nTappables < 44x44 (Apple/Android Accessible Recommendation Violation): ${touchTargets.under44.length}`);
console.table(touchTargets.under44.slice(0, 30));

console.log('\n=== SEMANTICS & ACCESSIBILITY AUDIT ===');
console.log(`Unlabeled Icon Buttons (missing tooltip or Semantics label): ${semanticsAudit.unlabeledButtons.length}`);
console.table(semanticsAudit.unlabeledButtons.slice(0, 25));

console.log(`\nImages missing semanticLabel or excludeFromSemantics: ${semanticsAudit.unlabeledImages.length}`);
console.table(semanticsAudit.unlabeledImages.slice(0, 25));

console.log(`\nTextFields missing labels/hints/semantics: ${semanticsAudit.unlabeledFields.length}`);
console.table(semanticsAudit.unlabeledFields);

console.log(`\nColor-Alone Status Indicators (Circles/Boxes indicating state without icon/text/semantics): ${semanticsAudit.colorOnlyStatus.length}`);
console.table(semanticsAudit.colorOnlyStatus);

console.log(`\nAnimations without Reduced Motion Support: ${semanticsAudit.animationsWithoutReduceMotion.length}`);
console.table(semanticsAudit.animationsWithoutReduceMotion);
