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

// 1. Gradients Audit
const gradientResults = [];
// 2. Tinted card pattern
const tintedCardResults = [];
// 3. Borders & Radii histograms
const borderColorHist = {};
const borderWidthHist = {};
const radiusHist = {};
// 4. Decorative shapes
const decorativeShapes = [];
// 5. Shadow/elevation
const shadowHist = {};
const elevationHist = {};
// 6. Header implementations per screen
const headerAudit = [];
// 7. Card background tints
const cardTintHist = {};

const HUE_PAIRS = [
  { name: 'green/brand', fill: /brandLight|greenLight|successLight|0xFFDCFCE7|0xFFE8F8D8|green\[50\]/i, border: /brandPrimary|brandDark|borderBrand|green|success|0xFF58CC02|0xFF16A34A|green\[300\]/i },
  { name: 'orange', fill: /orangeLight|warningLight|0xFFFFEDD5|0xFFFEF3C7|orange\[50\]/i, border: /orange|warning|orangeBorder|warningBorder|0xFFFF9600|0xFFEA8000/i },
  { name: 'blue', fill: /blueLight|infoLight|0xFFE0F2FE|0xFFEFF6FF|blue\[50\]/i, border: /blue|info|infoBorder|0xFF1CB0F6|0xFF3B82F6/i },
  { name: 'purple', fill: /purpleLight|0xFFF3E8FF|purple\[50\]/i, border: /purple|purpleBorder|0xFF8B5CF6|0xFF7C3AED/i },
  { name: 'red/error', fill: /errorLight|0xFFFEE2E2|red\[50\]/i, border: /error|errorBorder|0xFFEF4444|red/i },
];

for (const filePath of files) {
  const relPath = path.relative(path.resolve(__dirname, '../..'), filePath);
  const content = fs.readFileSync(filePath, 'utf8');
  const lines = content.split('\n');

  // Skip theme definition files for usage audit (or note them)
  const isThemeDef = relPath.startsWith('lib/theme/');

  lines.forEach((line, idx) => {
    const lineNum = idx + 1;

    // --- A1.1 Gradients ---
    if (line.match(/\b(LinearGradient|RadialGradient|SweepGradient|AppGradients\.\w+)/)) {
      const match = line.match(/\b(LinearGradient|RadialGradient|SweepGradient|AppGradients\.\w+)/)[0];
      // Check if inside mascot/illustration
      const isIllustration = relPath.includes('mascot') || relPath.includes('vector_') || relPath.includes('silhouette') || line.includes('mascot') || line.includes('sun') || line.includes('moon') || line.includes('sky');
      gradientResults.push({
        file: relPath,
        line: lineNum,
        type: match,
        kind: isIllustration ? 'illustration' : 'decorative',
        snippet: line.trim()
      });
    }

    // --- A1.3 Borders & Radii ---
    // Border widths: width:\s*([^,)]+)
    const widthMatches = line.matchAll(/width:\s*([A-Za-z0-9_.]+(\([A-Za-z0-9_.]+\))?)/g);
    for (const m of widthMatches) {
      if (line.includes('BorderSide') || line.includes('Border.all') || line.includes('AppStroke') || line.includes('AppBorders')) {
        const val = m[1].trim();
        borderWidthHist[val] = (borderWidthHist[val] || 0) + 1;
      }
    }
    // Direct AppStroke references
    const strokeMatches = line.matchAll(/AppStroke\.(\w+)/g);
    for (const m of strokeMatches) {
      const val = `AppStroke.${m[1]}`;
      borderWidthHist[val] = (borderWidthHist[val] || 0) + 1;
    }

    // Border colors
    const borderColorMatches = line.matchAll(/(?:color|borderColor):\s*([A-Za-z0-9_.]+(\([^)]*\))?)/g);
    for (const m of borderColorMatches) {
      if (line.includes('BorderSide') || line.includes('Border.all') || line.includes('AppBorders') || line.includes('borderColor')) {
        const val = m[1].trim();
        borderColorHist[val] = (borderColorHist[val] || 0) + 1;
      }
    }

    // Radius
    const radiusMatches = line.matchAll(/(?:circular|Radius\.circular|AppRadius\.)\s*\(?([A-Za-z0-9_.]+)\)?/g);
    for (const m of radiusMatches) {
      const val = m[0].trim();
      radiusHist[val] = (radiusHist[val] || 0) + 1;
    }

    // --- A1.4 Decorative shapes ---
    if (line.includes('BoxShape.circle')) {
      decorativeShapes.push({
        file: relPath,
        line: lineNum,
        snippet: line.trim()
      });
    }
    if (line.includes('CustomPaint(') || line.includes('CustomPainter')) {
      decorativeShapes.push({
        file: relPath,
        line: lineNum,
        snippet: line.trim(),
        type: 'CustomPaint'
      });
    }

    // --- A1.5 Shadows & Elevation ---
    if (line.includes('BoxShadow') || line.includes('shadowSm') || line.includes('shadowMd') || line.includes('shadowCard')) {
      const match = line.match(/AppElevation\.\w+|BoxShadow\([^)]*\)/);
      const val = match ? match[0] : 'BoxShadow';
      shadowHist[val] = (shadowHist[val] || 0) + 1;
    }
    const elevMatch = line.match(/\belevation:\s*([0-9.]+)/);
    if (elevMatch) {
      elevationHist[elevMatch[1]] = (elevationHist[elevMatch[1]] || 0) + 1;
    }
  });

  // Multi-line block inspection for tinted-card pattern & card backgrounds
  // We search for Container or AppCard blocks with both color/fill and border
  const blockRegex = /(?:Container|AppCard|BoxDecoration)\s*\([\s\S]*?\n\s*\)/g;
  let match;
  while ((match = blockRegex.exec(content)) !== null) {
    const block = match[0];
    const blockStartLine = content.substring(0, match.index).split('\n').length;
    
    // Check tinted card pattern
    for (const pair of HUE_PAIRS) {
      if (pair.fill.test(block) && pair.border.test(block)) {
        // extract fill token and border token
        const fillMatch = block.match(/(?:color|backgroundColor):\s*([^\n,]+)/);
        const borderMatch = block.match(/(?:borderColor|border|BorderSide\s*\(\s*color):\s*([^\n,]+)/);
        tintedCardResults.push({
          file: relPath,
          line: blockStartLine,
          hue: pair.name,
          fill: fillMatch ? fillMatch[1].trim() : 'matched ' + pair.name,
          border: borderMatch ? borderMatch[1].trim() : 'matched ' + pair.name,
          snippet: block.split('\n').slice(0, 5).join(' ').trim()
        });
      }
    }

    // Card background tints histogram
    const cardBgMatch = block.match(/(?:color|backgroundColor):\s*(AppColors\.\w+|Colors\.\w+(?:\[\d+\])?|Color\(0x\w+\))/);
    if (cardBgMatch) {
      const bg = cardBgMatch[1];
      if (/Light|surfaceSubtle|50\]|slate100|slate50/i.test(bg)) {
        cardTintHist[bg] = (cardTintHist[bg] || 0) + 1;
      }
    }
  }

  // --- A1.6 Header Implementation Audit for Screens ---
  if (relPath.startsWith('lib/screens/')) {
    let headerType = 'None / Custom';
    if (content.includes('AppTopBar.shell')) {
      headerType = 'AppTopBar.shell';
    } else if (content.includes('AppTopBar.page')) {
      headerType = 'AppTopBar.page';
    } else if (content.includes('DuolingoPageHeader')) {
      headerType = 'DuolingoPageHeader (Legacy)';
    } else if (content.includes('DuolingoAppBar')) {
      headerType = 'DuolingoAppBar (Legacy)';
    } else if (content.includes('AppBar(')) {
      headerType = 'Standard Flutter AppBar';
    } else if (content.includes('LinearGradient') && (content.includes('header') || content.includes('appBar') || content.includes('TopBar') || content.includes('Container('))) {
      headerType = 'Custom Gradient Header';
    }
    headerAudit.push({
      screen: relPath,
      header: headerType
    });
  }
}

console.log('=== A1.1 GRADIENTS AUDIT ===');
console.log(`Total gradient occurrences: ${gradientResults.length}`);
console.table(gradientResults);

console.log('\n=== A1.1 GRADIENT COUNTS BY FILE ===');
const gradByFile = {};
gradientResults.forEach(g => {
  gradByFile[g.file] = (gradByFile[g.file] || { total: 0, decorative: 0, illustration: 0 });
  gradByFile[g.file].total++;
  gradByFile[g.file][g.kind]++;
});
console.table(Object.entries(gradByFile).map(([file, c]) => ({ file, ...c })));

console.log('\n=== A1.2 TINTED CARD PATTERN (Fill + Same Hue Border) ===');
console.log(`Total occurrences: ${tintedCardResults.length}`);
console.table(tintedCardResults);

console.log('\n=== A1.3 BORDER COLOR HISTOGRAM ===');
console.table(Object.entries(borderColorHist).sort((a,b)=>b[1]-a[1]).slice(0, 30).map(([token, count]) => ({ token, count })));

console.log('\n=== A1.3 BORDER WIDTH HISTOGRAM ===');
console.table(Object.entries(borderWidthHist).sort((a,b)=>b[1]-a[1]).map(([token, count]) => ({ token, count })));

console.log('\n=== A1.3 RADIUS HISTOGRAM ===');
console.table(Object.entries(radiusHist).sort((a,b)=>b[1]-a[1]).slice(0, 30).map(([token, count]) => ({ token, count })));

console.log('\n=== A1.4 DECORATIVE SHAPES ===');
console.log(`Total decorative shapes (BoxShape.circle, CustomPaint): ${decorativeShapes.length}`);
console.table(decorativeShapes.slice(0, 30));

console.log('\n=== A1.5 SHADOW & ELEVATION HISTOGRAM ===');
console.log('Shadows:');
console.table(Object.entries(shadowHist).sort((a,b)=>b[1]-a[1]).map(([token, count]) => ({ token, count })));
console.log('Elevations:');
console.table(Object.entries(elevationHist).sort((a,b)=>b[1]-a[1]).map(([val, count]) => ({ elevation: val, count })));

console.log('\n=== A1.6 SCREEN HEADERS AUDIT ===');
console.table(headerAudit);

console.log('\n=== A1.7 CARD BACKGROUND TINT HISTOGRAM ===');
console.table(Object.entries(cardTintHist).sort((a,b)=>b[1]-a[1]).map(([token, count]) => ({ token, count })));
