const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const LIB_DIR = path.join(ROOT, 'lib');

function walk(dir) {
  let files = [];
  if (!fs.existsSync(dir)) return files;
  for (const item of fs.readdirSync(dir)) {
    const full = path.join(dir, item);
    const stat = fs.statSync(full);
    if (stat.isDirectory()) {
      files = files.concat(walk(full));
    } else if (full.endsWith('.dart')) {
      files.push(full);
    }
  }
  return files;
}

function getEnclosingWidget(content, charPos) {
  let searchStart = Math.max(0, charPos - 1200);
  let chunk = content.slice(searchStart, charPos);
  let matches = [...chunk.matchAll(/\b([A-Z][A-Za-z0-9_]*)\s*\(/g)];
  if (!matches.length) return null;
  
  for (let m = matches.length - 1; m >= 0; m--) {
    let match = matches[m];
    let openParen = searchStart + match.index + match[0].indexOf('(');
    let depth = 1;
    let i = openParen + 1;
    while (i < content.length && depth > 0) {
      if (content[i] === '(') depth++;
      else if (content[i] === ')') depth--;
      i++;
    }
    if (openParen <= charPos && charPos <= i) {
      return {
        widgetName: match[1],
        body: content.slice(openParen, i),
        start: openParen,
        end: i
      };
    }
  }
  return null;
}

function runAudit(options = {}) {
  const root = options.root || ROOT;
  const libDir = options.libDir || LIB_DIR;
  
  const files = options.files || walk(libDir).filter(f => {
    const rel = path.relative(root, f).replace(/\\/g, '/');
    return !rel.startsWith('lib/theme/') && !rel.startsWith('lib/widgets/ds/');
  });

  const categories = {
    colors: { name: 'Hardcoded Colors', count: 0, items: [] },
    textStyles: { name: 'Hardcoded Text Styles', count: 0, items: [] },
    spacing: { name: 'Hardcoded Spacing', count: 0, items: [] },
    radii: { name: 'Hardcoded Radii', count: 0, items: [] },
    decorations: { name: 'Hardcoded Borders, Shadows & Gradients', count: 0, items: [] },
    sizes: { name: 'Hardcoded Sizes', count: 0, items: [] },
    duplicatedWidgets: { name: 'Duplicated Headers, Cards & Avatars', count: 0, items: [] },
    fixedOverflows: { name: 'Fixed Dimensions (Overflow Risks)', count: 0, items: [] },
  };

  const fileCounts = {};

  files.forEach(f => {
    const rel = path.relative(root, f).replace(/\\/g, '/');
    fileCounts[rel] = { total: 0, categories: {} };
    for (const k of Object.keys(categories)) {
      fileCounts[rel].categories[k] = 0;
    }

    const content = fs.readFileSync(f, 'utf8');
    const lines = content.split('\n');

    lines.forEach((line, idx) => {
      const lineNum = idx + 1;
      const trimmed = line.trim();
      if (trimmed.startsWith('//') || trimmed.startsWith('///') || trimmed.startsWith('*') || trimmed.startsWith('/*')) return;

      function record(catKey, desc) {
        categories[catKey].count++;
        categories[catKey].items.push({ file: rel, line: lineNum, snippet: trimmed, desc });
        fileCounts[rel].total++;
        fileCounts[rel].categories[catKey]++;
      }

      // Mutual exclusivity priority chain: Each line is evaluated once, ensuring zero double-counting across categories.
      
      // 1. Duplicated widgets (DuolingoAppBar, DuolingoPageHeader, custom AppBar, DuolingoCard, DuolingoButton, Duolingo3DButton, inline avatars)
      if (/\b(DuolingoAppBar|DuolingoPageHeader|DuolingoCard|DuolingoButton|Duolingo3DButton|_TopiBoyAvatar|_HijabGirlAvatar|CircleAvatar)\b/.test(line) ||
          (/\bAppBar\s*\(/.test(line) && !/ThemeData|Theme\./.test(line))) {
        let desc = 'Duplicated component';
        if (/DuolingoAppBar/.test(line)) desc = 'DuolingoAppBar header';
        else if (/DuolingoPageHeader/.test(line)) desc = 'DuolingoPageHeader';
        else if (/AppBar\(/.test(line)) desc = 'Custom Flutter AppBar';
        else if (/DuolingoCard/.test(line)) desc = 'DuolingoCard widget';
        else if (/Duolingo3DButton|DuolingoButton/.test(line)) desc = 'Duolingo button widget';
        else if (/CircleAvatar|_TopiBoyAvatar|_HijabGirlAvatar/.test(line)) desc = 'Inline avatar widget';
        record('duplicatedWidgets', desc);
        return;
      }

      // 2. Fixed overflow risks: MUST NOT flag SizedBox spacers, icon/avatar boxes, or dividers.
      // Only flag fixed width/height on containers, buttons, chips or labels that contain Text.
      const isSpacer = /\b(const\s+)?SizedBox\s*\(\s*(width|height)\s*:\s*\d+(\.\d+)?\s*\)/.test(line);
      const isBorderStroke = /border|stroke|BorderSide|elevation|Border\.all/i.test(line);
      const isResponsive = /isTablet|mediaQuery|size\.(width|height)|constraints/i.test(line);

      if (!isSpacer && !isBorderStroke && !isResponsive && /\b(width|height)\s*:\s*[1-9]\d{0,3}\b/.test(line)) {
        let charPos = lines.slice(0, idx).join('\n').length + 1;
        let enclosing = getEnclosingWidget(content, charPos);
        if (enclosing) {
          if (enclosing.widgetName === 'SizedBox' && !/\bchild\s*:/.test(enclosing.body)) {
            return;
          }
          const isButtonOrChip = /\b(Button|Chip|DSButton|Duolingo3DButton|DuolingoButton)\b/.test(enclosing.widgetName);
          const hasTextChild = /\b(Text|LocalizedText|TextSpan)\s*\(/.test(enclosing.body) || /\blabel\s*:\s*(context\.t|['\"])/.test(enclosing.body);
          const isIconOrAvatarOnly = /child\s*:\s*(Icon|Image|CircleAvatar|FacelessSilhouette|SvgPicture)\b/.test(enclosing.body) && !hasTextChild;
          const isDivider = /\b(Divider|VerticalDivider)\b/.test(enclosing.widgetName) || (/width\s*:\s*1(\.0)?\b/.test(line) && !hasTextChild);

          if ((isButtonOrChip || hasTextChild) && !isIconOrAvatarOnly && !isDivider) {
            record('fixedOverflows', `Fixed dimension on ${enclosing.widgetName} containing text (overflow risk)`);
            return;
          }
        }
      }

      // 3. Borders, shadows & gradients
      if (/\b(Border\.all|BorderSide|BoxShadow|LinearGradient|RadialGradient|SweepGradient)\b/.test(line)) {
        let desc = 'Border/Shadow/Gradient';
        if (/Border\.all|BorderSide/.test(line)) desc = 'Border.all / BorderSide stroke';
        else if (/BoxShadow/.test(line)) desc = 'BoxShadow decoration';
        else if (/Gradient/.test(line)) desc = 'Gradient decoration';
        record('decorations', desc);
        return;
      }

      // 4. Radii
      if (/\b(BorderRadius\.circular|Radius\.circular|BorderRadius\.all|BorderRadius\.only)\b/.test(line)) {
        record('radii', 'BorderRadius / Radius literal number');
        return;
      }

      // 5. Colors (Color(0x...), Colors.xxx, withValues/withOpacity, Hex string)
      // Must not match AppColors.x. Uses negative lookbehind (?<![A-Za-z0-9_])Colors\.
      // Treat Colors.transparent as allowed.
      const hasColorHex = /Color\(0x[0-9a-fA-F]+\)/.test(line);
      const hasColorsConst = /(?<![A-Za-z0-9_])Colors\.(?!transparent\b)[a-zA-Z]+/.test(line);
      const hasOpacity = /\.(withOpacity|withValues)\(/.test(line) && !/AppColors\./.test(line);
      const hasHexString = /#[0-9a-fA-F]{6}/.test(line);

      if (hasColorHex || hasColorsConst || hasOpacity || hasHexString) {
        let desc = 'Hardcoded color';
        if (hasColorsConst && hasOpacity) desc = 'Colors.xxx with opacity modifier (compound color on single line)';
        else if (hasColorHex) desc = 'Color(0x...) literal';
        else if (hasColorsConst) desc = 'Colors.xxx literal';
        else if (hasOpacity) desc = 'Opacity / withValues modifier';
        else if (hasHexString) desc = 'Hex color string literal';
        record('colors', desc);
        return;
      }

      // 6. Text Styles (TextStyle, fontSize, FontWeight, letterSpacing, GoogleFonts)
      if (/\bTextStyle\s*\(/.test(line) ||
          /\bfontSize\s*:\s*\d+(\.\d+)?\b/.test(line) ||
          /\bFontWeight\.[a-zA-Z0-9]+\b/.test(line) ||
          /\bletterSpacing\s*:\s*-?\d+(\.\d+)?\b/.test(line) ||
          /\bGoogleFonts\.[a-zA-Z0-9]+\b/.test(line)) {
        let desc = 'Text style literal';
        if (/TextStyle\(/.test(line)) desc = 'TextStyle(...) declaration';
        else if (/fontSize/.test(line)) desc = 'fontSize literal';
        else if (/FontWeight/.test(line)) desc = 'FontWeight literal';
        else if (/letterSpacing/.test(line)) desc = 'letterSpacing literal';
        else if (/GoogleFonts/.test(line)) desc = 'GoogleFonts direct call';
        record('textStyles', desc);
        return;
      }

      // 7. Spacing (EdgeInsets, SizedBox spacer, Padding)
      if (/\bEdgeInsets\.(all|symmetric|only|fromLTRB)\(/.test(line) ||
          /\bSizedBox\(\s*(height|width)\s*:\s*\d+/.test(line) ||
          /\bPadding\(\s*padding\s*:\s*EdgeInsets/.test(line)) {
        let desc = 'Hardcoded spacing';
        if (/EdgeInsets/.test(line)) desc = 'EdgeInsets literal';
        else if (/SizedBox/.test(line)) desc = 'SizedBox spacer literal dimension';
        else if (/Padding/.test(line)) desc = 'Padding widget with inline EdgeInsets';
        record('spacing', desc);
        return;
      }

      // 8. Sizes (iconSize, size: n on icons, toolbarHeight, preferredSize)
      if ((/\biconSize\s*:\s*\d+/.test(line) || (/\bsize\s*:\s*\d+(\.\d+)?\b/.test(line) && /Icon\b/i.test(line))) ||
          /\btoolbarHeight\s*:\s*\d+/.test(line) ||
          /\bpreferredSize\s*:\s*Size/.test(line)) {
        let desc = 'Hardcoded size';
        if (/toolbarHeight|preferredSize/.test(line)) desc = 'App bar height literal';
        else desc = 'Icon or widget size literal';
        record('sizes', desc);
        return;
      }
    });
  });

  let grandTotal = 0;
  for (const [key, cat] of Object.entries(categories)) {
    grandTotal += cat.count;
  }

  const sortedFiles = Object.entries(fileCounts)
    .filter(([_, v]) => v.total > 0)
    .sort((a, b) => b[1].total - a[1].total);

  return {
    categories,
    fileCounts,
    grandTotal,
    sortedFiles
  };
}

if (require.main === module) {
  const result = runAudit();
  console.log('=== VALIDATED DESIGN AUDIT SUMMARY (lib/theme/ & lib/widgets/ds/ EXCLUDED) ===');
  for (const [key, cat] of Object.entries(result.categories)) {
    console.log(`${cat.name}: ${cat.count}`);
  }
  console.log(`TOTAL OFFENDING LINES: ${result.grandTotal}`);

  console.log('\nTop 10 Offending Files:');
  result.sortedFiles.slice(0, 10).forEach(([file, data], idx) => {
    console.log(`${idx + 1}. ${file}: ${data.total} lines`);
  });

  // Write updated docs/design-audit.md
  let md = `# Design Audit Report (Validated)

This report catalogs all design system violations across \`lib/\` (**excluding \`lib/theme/\` and \`lib/widgets/ds/\`** where tokens and shared components live).
Each offending line is assigned to exactly one primary category, ensuring **zero double-counting** across categories.

---

## 1. Summary by Category

| Category | Offending Lines Count | Detection Rule & Description |
|---|:---:|---|
| **Hardcoded Colors** | **${result.categories.colors.count}** | Raw \`Color(0x...)\`, \`Colors.xxx\` (excluding \`Colors.transparent\` and \`AppColors\`), hex strings, and inline opacity modifiers |
| **Hardcoded Text Styles** | **${result.categories.textStyles.count}** | Inline \`TextStyle\`, \`fontSize\`, \`FontWeight\`, \`letterSpacing\`, and direct font calls |
| **Hardcoded Spacing** | **${result.categories.spacing.count}** | Literal \`EdgeInsets\`, \`SizedBox(height/width)\` spacers, and \`Padding\` values |
| **Hardcoded Radii** | **${result.categories.radii.count}** | Explicit \`BorderRadius.circular(n)\` and \`Radius.circular(n)\` numbers |
| **Borders, Shadows & Gradients** | **${result.categories.decorations.count}** | Inline \`Border.all\`, \`BorderSide\`, \`BoxShadow\`, and \`LinearGradient\` decorations |
| **Hardcoded Sizes** | **${result.categories.sizes.count}** | Fixed icon sizes, avatar radii, and app bar height literals |
| **Duplicated UI Widgets** | **${result.categories.duplicatedWidgets.count}** | Scattered headers (\`DuolingoAppBar\`, \`DuolingoPageHeader\`, custom \`AppBar\`), cards, buttons, and inline avatars |
| **Fixed Overflow Risks** | **${result.categories.fixedOverflows.count}** | Hardcoded container/button/chip widths with Text vulnerable to overflow in longer languages (\`bn\`, \`hi\`, \`it\`) |
| **TOTAL UNIQUE OFFENDING LINES** | **${result.grandTotal}** | **Total design system violations (Zero double-counted lines)** |

---

## 2. Top 10 Offending Files

| Rank | File Path | Total Lines | Category Breakdown (Directly Computed) |
|:---:|---|:---:|---|
`;

  result.sortedFiles.slice(0, 10).forEach(([file, data], idx) => {
    const breakdown = Object.entries(data.categories)
      .filter(([_, count]) => count > 0)
      .map(([catKey, c]) => `${result.categories[catKey].name}: ${c}`)
      .join(', ');
    md += `| ${idx + 1} | [\`${file}\`](file:///${path.join(ROOT, file)}) | **${data.total}** | ${breakdown} |\n`;
  });

  md += `\n---

## 3. All Duplicated Widgets (${result.categories.duplicatedWidgets.count} occurrences)

| File & Line | Component | Code Snippet |
|---|---|---|
`;

  result.categories.duplicatedWidgets.items.forEach(item => {
    const escaped = item.snippet.replace(/\|/g, '\\|').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    md += `| [\`${item.file}:${item.line}\`](file:///${path.join(ROOT, item.file)}#L${item.line}) | ${item.desc} | \`${escaped}\` |\n`;
  });

  md += `\n---

## 4. All Fixed Dimensions / Overflow Risks (${result.categories.fixedOverflows.count} occurrences)

| File & Line | Component | Code Snippet |
|---|---|---|
`;

  result.categories.fixedOverflows.items.forEach(item => {
    const escaped = item.snippet.replace(/\|/g, '\\|').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    md += `| [\`${item.file}:${item.line}\`](file:///${path.join(ROOT, item.file)}#L${item.line}) | ${item.desc} | \`${escaped}\` |\n`;
  });

  fs.writeFileSync(path.join(ROOT, 'docs/design-audit.md'), md, 'utf8');
  console.log('Successfully wrote validated docs/design-audit.md');
}

module.exports = {
  walk,
  getEnclosingWidget,
  runAudit
};
