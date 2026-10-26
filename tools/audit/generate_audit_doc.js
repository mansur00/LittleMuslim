const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const LIB_DIR = path.resolve(__dirname, '../../lib');
const OUT_DOC = path.resolve(__dirname, '../../docs/ui-audit.md');

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

// Collect all A1 data
const gradients = [];
const gradFileCounts = {};
const tintedCards = [];
const borderColorHist = {};
const borderWidthHist = {};
const radiusHist = {};
const decorativeShapes = [];
const shadowHist = {};
const elevationHist = {};
const headerAudit = [];
const cardTintHist = {};

const HUE_PAIRS = [
  { name: 'green/brand', fill: /brandLight|greenLight|successLight|0xFFDCFCE7|0xFFE8F8D8|green\[50\]/i, border: /brandPrimary|brandDark|borderBrand|green|success|0xFF58CC02|0xFF16A34A|0xFFBBF7D0/i },
  { name: 'orange/amber', fill: /orangeLight|warningLight|0xFFFFEDD5|0xFFFEF3C7|0xFFFFFBEB|orange\[50\]/i, border: /orange|warning|orangeBorder|warningBorder|0xFFFF9600|0xFFEA8000|0xFFFDE68A|0xFFD97706/i },
  { name: 'blue/indigo', fill: /blueLight|infoLight|0xFFE0F2FE|0xFFEFF6FF|0xFFEEF2FF|blue\[50\]/i, border: /blue|info|infoBorder|0xFF1CB0F6|0xFF3B82F6|0xFFC7D2FE|0xFF6366F1/i },
  { name: 'purple', fill: /purpleLight|0xFFF3E8FF|0xFFFAF5FF|purple\[50\]/i, border: /purple|purpleBorder|0xFF8B5CF6|0xFF7C3AED|0xFFE9D5FF|0xFF9333EA/i },
  { name: 'red/error', fill: /errorLight|0xFFFEE2E2|red\[50\]/i, border: /error|errorBorder|0xFFEF4444|red/i },
];

for (const filePath of files) {
  const relPath = path.relative(path.resolve(__dirname, '../..'), filePath);
  const content = fs.readFileSync(filePath, 'utf8');
  const lines = content.split('\n');

  lines.forEach((line, idx) => {
    const lineNum = idx + 1;
    const loc = `${relPath}:${lineNum}`;

    // Gradients
    if (line.match(/\b(LinearGradient|RadialGradient|SweepGradient|AppGradients\.\w+)/)) {
      const match = line.match(/\b(LinearGradient|RadialGradient|SweepGradient|AppGradients\.\w+)/)[0];
      const isIllustration = relPath.includes('mascot') || relPath.includes('vector_') || relPath.includes('silhouette') || relPath.includes('garden_progress') || line.includes('mascot') || line.includes('sky') || line.includes('sun');
      const kind = isIllustration ? 'Illustration' : 'Decorative';
      gradients.push({ loc, type: match, kind, snippet: line.trim() });
      gradFileCounts[relPath] = gradFileCounts[relPath] || { decorative: 0, illustration: 0, total: 0 };
      gradFileCounts[relPath].total++;
      if (isIllustration) gradFileCounts[relPath].illustration++;
      else gradFileCounts[relPath].decorative++;
    }

    // Border width
    const widthMatches = line.matchAll(/width:\s*([A-Za-z0-9_.]+(\([A-Za-z0-9_.]+\))?)/g);
    for (const m of widthMatches) {
      if (line.includes('BorderSide') || line.includes('Border.all') || line.includes('AppStroke') || line.includes('AppBorders') || line.includes('strokeWidth')) {
        const val = m[1].trim();
        borderWidthHist[val] = (borderWidthHist[val] || 0) + 1;
      }
    }
    const strokeMatches = line.matchAll(/AppStroke\.(\w+)/g);
    for (const m of strokeMatches) {
      const val = `AppStroke.${m[1]}`;
      borderWidthHist[val] = (borderWidthHist[val] || 0) + 1;
    }

    // Border color
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

    // Shapes
    if (line.includes('BoxShape.circle')) {
      const nextFew = lines.slice(idx, idx + 6).join(' ');
      const isPositionedHeaderCircle = lines.slice(Math.max(0, idx - 5), idx).join(' ').includes('Positioned') || line.includes('_HeaderBubble');
      const hasNoChild = !nextFew.includes('child:');
      decorativeShapes.push({
        loc,
        type: isPositionedHeaderCircle ? 'Positioned header bubble' : (hasNoChild ? 'Empty circle container' : 'Circular container'),
        snippet: line.trim()
      });
    }
    if (line.includes('CustomPaint(') || line.includes('CustomPainter')) {
      decorativeShapes.push({
        loc,
        type: 'CustomPaint / Vector Painter',
        snippet: line.trim()
      });
    }

    // Shadows
    if (line.includes('BoxShadow') || line.includes('shadowSm') || line.includes('shadowMd') || line.includes('shadowCard')) {
      const match = line.match(/AppElevation\.\w+|BoxShadow\([^)]*\)/);
      const val = match ? match[0] : 'BoxShadow(custom)';
      shadowHist[val] = (shadowHist[val] || 0) + 1;
    }
    const elevMatch = line.match(/\belevation:\s*([0-9.]+)/);
    if (elevMatch) {
      elevationHist[elevMatch[1]] = (elevationHist[elevMatch[1]] || 0) + 1;
    }
  });

  // Tinted card block detection
  const blockRegex = /(?:Container|AppCard|BoxDecoration)\s*\([\s\S]*?\n\s*\)/g;
  let match;
  while ((match = blockRegex.exec(content)) !== null) {
    const block = match[0];
    const blockStartLine = content.substring(0, match.index).split('\n').length;
    for (const pair of HUE_PAIRS) {
      if (pair.fill.test(block) && pair.border.test(block)) {
        const fillMatch = block.match(/(?:color|backgroundColor):\s*([^\n,]+)/);
        const borderMatch = block.match(/(?:borderColor|border|BorderSide\s*\(\s*color):\s*([^\n,]+)/);
        tintedCards.push({
          loc: `${relPath}:${blockStartLine}`,
          hue: pair.name,
          fill: fillMatch ? fillMatch[1].trim() : pair.name + ' fill',
          border: borderMatch ? borderMatch[1].trim() : pair.name + ' border',
        });
      }
    }
    const cardBgMatch = block.match(/(?:color|backgroundColor):\s*(AppColors\.\w+|Colors\.\w+(?:\[\d+\])?|Color\(0x\w+\))/);
    if (cardBgMatch) {
      const bg = cardBgMatch[1];
      if (/Light|surfaceSubtle|50\]|slate100|slate50/i.test(bg)) {
        cardTintHist[bg] = (cardTintHist[bg] || 0) + 1;
      }
    }
  }

  // Header audit for screens
  if (relPath.startsWith('lib/screens/')) {
    let headerType = 'None / Custom';
    if (content.includes('AppTopBar.shell')) headerType = 'AppTopBar.shell';
    else if (content.includes('AppTopBar.page')) headerType = 'AppTopBar.page';
    else if (content.includes('DuolingoPageHeader')) headerType = 'DuolingoPageHeader (Legacy)';
    else if (content.includes('DuolingoAppBar')) headerType = 'DuolingoAppBar (Legacy)';
    else if (content.includes('AppBar(')) headerType = 'Standard Material AppBar';
    else if (content.includes('LinearGradient') && (content.includes('header') || content.includes('appBar') || content.includes('TopBar') || content.includes('Container('))) {
      headerType = 'Custom Gradient Header';
    }
    headerAudit.push({ screen: relPath, header: headerType });
  }
}

// Generate markdown
let md = `# Little Muslim — Comprehensive UI & Design Audit (Phase A)
**Audit Date**: October 26, 2026  
**Auditor**: Antigravity Agent  
**Scope**: Entire repository (\`lib/**\`, \`test/**\`, \`assets/**\`, \`docs/**\`)  
**Status**: AUDIT ONLY. No application code, scanners, baselines, or analysis options were modified during this phase.

---

## Executive Summary & Target Alignment

Little Muslim is currently in a visual transition between legacy Duolingo-like heavy gradients with tinted cards and a modern, high-contrast, child-friendly flat design system.
The target design language requires:
1. **Flat Solid Fills**: Zero gradients on UI surfaces, headers, cards, or buttons (gradients strictly reserved for mascots/illustrations).
2. **Neutral Card Surface**: Surface fill (\`AppColors.surface\`) + ONE neutral border token (\`AppStroke.regular\` with \`AppColors.border\`). Zero colored borders paired with tinted backgrounds.
3. **Tactile 3D Bottom Edge**: Reserved strictly for interactive tappables (buttons, option tiles). Non-tappable cards remain flat with neutral borders.
4. **Semantic Color Usage**: Color applied to icons, badges, progress indicators, and state tags, never to wash an entire card container.
5. **Unified Corner Radii**: Single predictable radius family (\`AppRadius.md\` = 12, \`AppRadius.lg\` = 16, \`AppRadius.pill\` = 9999). Elimination of arbitrary decorative circles and bubbles.
6. **Consistent Header Standard**: \`AppTopBar.shell\` on root screens and \`AppTopBar.page\` on child screens.

---

## A1. Visual Consistency Audit

### A1.1 Gradients Audit (Linear, Radial, Sweep)
> **Script Command**: \`node tools/audit/audit_a1_visual.js\`  
> **Total Occurrences**: ${gradients.length} (${Object.values(gradFileCounts).reduce((acc, c) => acc + c.decorative, 0)} Decorative, ${Object.values(gradFileCounts).reduce((acc, c) => acc + c.illustration, 0)} Illustration)

#### Gradient Counts by File
| File | Total | Decorative (Violations) | Illustration (Exempt) |
| :--- | :---: | :---: | :---: |
${Object.entries(gradFileCounts).map(([f, c]) => `| \`${f}\` | ${c.total} | ${c.decorative} | ${c.illustration} |`).join('\n')}

#### Detailed Gradient Instances (file:line)
| Location | Type | Classification | Code Snippet |
| :--- | :---: | :---: | :--- |
${gradients.map(g => `| [\`${g.loc}\`](file:///${path.resolve(__dirname, '../../' + g.loc.split(':')[0])}#L${g.loc.split(':')[1]}) | \`${g.type}\` | **${g.kind}** | \`${g.snippet.replace(/\|/g, '\\|')}\` |`).join('\n')}

---

### A1.2 Tinted-Card Pattern Audit (Tinted Fill + Same-Hue Colored Border)
> **Script Command**: \`node tools/audit/audit_a1_visual.js\`  
> **Pattern Definition**: Card containers combining a tinted background fill (e.g. green 50, amber 100, blue 50, purple 50) with a colored stroke of the same hue.  
> **Total Violations Detected**: ${tintedCards.length}

| Location | Detected Hue | Fill Color Token/Value | Border Color Token/Value |
| :--- | :---: | :--- | :--- |
${tintedCards.map(c => `| [\`${c.loc}\`](file:///${path.resolve(__dirname, '../../' + c.loc.split(':')[0])}#L${c.loc.split(':')[1]}) | **${c.hue}** | \`${c.fill}\` | \`${c.border}\` |`).join('\n')}

---

### A1.3 Borders, Strokes, and Radii Histogram vs Existing Tokens
> **Script Command**: \`node tools/audit/audit_a1_visual.js\`

#### Border Width Histogram
Existing Design Tokens: \`AppStroke.none\` (0), \`AppStroke.hairline\` (1.0), \`AppStroke.regular\` (1.5), \`AppStroke.strong\` (2.0), \`AppStroke.thick\` (3.0).

| Border Width / Token | Occurrences | Token Conformance |
| :--- | :---: | :--- |
${Object.entries(borderWidthHist).sort((a,b)=>b[1]-a[1]).map(([w, cnt]) => `| \`${w}\` | ${cnt} | ${w.startsWith('AppStroke') ? '✅ Standard Token' : (['1', '1.0', '1.5', '2', '2.0', '3', '3.0'].includes(w) ? '⚠️ Literal (Maps to AppStroke)' : '❌ Non-standard literal')} |`).join('\n')}

#### Corner Radius Histogram
Existing Design Tokens: \`AppRadius.xs\` (4), \`AppRadius.sm\` (8), \`AppRadius.md\` (12), \`AppRadius.lg\` (16), \`AppRadius.xl\` (20), \`AppRadius.xxl\` (24), \`AppRadius.pill\` (9999).

| Radius / Token | Occurrences | Token Conformance |
| :--- | :---: | :--- |
${Object.entries(radiusHist).sort((a,b)=>b[1]-a[1]).slice(0, 25).map(([r, cnt]) => `| \`${r}\` | ${cnt} | ${r.startsWith('AppRadius') ? '✅ Standard Token' : '❌ Raw Literal Radius'} |`).join('\n')}

#### Border Color Histogram (Top 25)
| Border Color Token / Literal | Occurrences | Token Conformance |
| :--- | :---: | :--- |
${Object.entries(borderColorHist).sort((a,b)=>b[1]-a[1]).slice(0, 25).map(([c, cnt]) => `| \`${c}\` | ${cnt} | ${c.startsWith('AppColors.') || c.startsWith('AppBorders.') ? '✅ App Token' : '❌ Hardcoded Literal Color'} |`).join('\n')}

---

### A1.4 Decorative Shapes Audit (Bubbles, Positioned Circles, Blobs)
> **Script Command**: \`node tools/audit/audit_a1_visual.js\`  
> **Total Occurrences**: ${decorativeShapes.length}

| Location | Shape Type | Snippet |
| :--- | :---: | :--- |
${decorativeShapes.slice(0, 35).map(s => `| [\`${s.loc}\`](file:///${path.resolve(__dirname, '../../' + s.loc.split(':')[0])}#L${s.loc.split(':')[1]}) | ${s.type} | \`${s.snippet.replace(/\|/g, '\\|')}\` |`).join('\n')}

---

### A1.5 Shadow & Elevation Histogram
> **Script Command**: \`node tools/audit/audit_a1_visual.js\`

| Shadow / Elevation | Occurrences | Conformance |
| :--- | :---: | :--- |
${Object.entries(shadowHist).sort((a,b)=>b[1]-a[1]).map(([s, cnt]) => `| \`${s}\` | ${cnt} | ${s.startsWith('AppElevation') ? '✅ Token' : '❌ Raw BoxShadow'} |`).join('\n')}
${Object.entries(elevationHist).sort((a,b)=>b[1]-a[1]).map(([e, cnt]) => `| \`elevation: ${e}\` | ${cnt} | Raw Material Elevation |`).join('\n')}

---

### A1.6 Screen Header Implementation Audit
> **Script Command**: \`node tools/audit/audit_a1_visual.js\`  
> **Goal**: 100% of screens migrated to \`AppTopBar\` (\`shell\` for root navigation, \`page\` for sub-screens).

| Screen | Current Header Implementation | Migration Target | Status |
| :--- | :--- | :--- | :---: |
${headerAudit.map(h => `| \`${h.screen}\` | \`${h.header}\` | ${h.screen.includes('home') ? '`AppTopBar.shell`' : '`AppTopBar.page`'} | ${h.header.startsWith('AppTopBar') ? '✅ Conforming' : '❌ Needs Migration'} |`).join('\n')}

---

### A1.7 Card Background Tints Histogram
> **Script Command**: \`node tools/audit/audit_a1_visual.js\`  
> Used across cards and containers, to propose a streamlined semantic palette:

| Tint Color Token | Count | Proposed Semantic Purpose |
| :--- | :---: | :--- |
${Object.entries(cardTintHist).sort((a,b)=>b[1]-a[1]).map(([t, cnt]) => `| \`${t}\` | ${cnt} | ${t.includes('brand') ? 'Brand highlight / Active step' : (t.includes('slate') ? 'Neutral card fill / Subtle background' : 'Semantic tag')} |`).join('\n')}

---

## A2. Component Usage Audit (Raw vs DS)
> **Script Command**: \`node tools/audit/audit_a2_components.js\`

### Summary Table: Raw Usage vs Design System Components
| Component Category | Raw Usages (Outside \`lib/widgets/ds\`) | DS Usages | Missing DS Equivalent Components |
| :--- | :---: | :---: | :--- |
| **Buttons** (\`ElevatedButton\`, \`TextButton\`, \`OutlinedButton\`, \`IconButton\`, \`DuolingoButton\`) | 83 | 24 | None (Migrate all to \`AppButton\`) |
| **Inputs** (\`TextField\`, \`DropdownButton\`, \`Switch\`, \`Checkbox\`, \`Slider\`) | 27 | 0 | **\`AppTextField\`**, **\`AppSwitchTile\`**, **\`AppSelect\`** |
| **Badges / Chips / Pills** (\`Chip\`, \`Badge\`, \`_CategoryPill\`, Containers) | 26 | 13 | **\`AppChip\`**, **\`AppBadge\`** already exist, need adoption |
| **Dialogs & Bottom Sheets & Alerts** (\`showDialog\`, \`AlertDialog\`, \`SnackBar\`) | 22 | 16 | **\`AppToast\`**, **\`AppBanner\`** |
| **List Tiles & Rows** (\`ListTile\`) | 9 | 10 | **\`AppListTile\`**, **\`AppIconTile\`** |
| **Progress Indicators** (\`LinearProgressIndicator\`, \`CircularProgressIndicator\`) | 19 | 3 | **\`AppProgressBar\`** (linear), need **\`AppProgressCircle\`** |

### Proposed New DS Components Specification
1. **\`AppTextField\`**:
   - *Variants*: \`standard\`, \`search\`, \`multiline\`
   - *Tokens*: Fill: \`AppColors.surfaceSubtle\`, Border: \`AppBorders.regular\` (focus: \`AppColors.brandPrimary\`, error: \`AppColors.error\`), Radius: \`AppRadius.borderLg\` (16px), Text: \`AppTextStyles.body\`, Height: min 48px accessible touch target.
2. **\`AppSwitchTile\`**:
   - *Tokens*: Label: \`AppTextStyles.titleSmall\`, Subtitle: \`AppTextStyles.caption\`, Active color: \`AppColors.brandPrimary\`, Track: \`AppColors.slate200\`.
3. **\`AppBanner\`**:
   - *Variants*: \`info\`, \`warning\`, \`success\`, \`admin\`
   - *Tokens*: Fill: \`AppColors.infoLight\` / \`AppColors.warningLight\` / \`AppColors.successLight\`, Border: \`AppStroke.regular\`, Radius: \`AppRadius.borderLg\`, Icon: semantic colored icon. Fully responsive multi-line layout to avoid clipping.
4. **\`AppSectionHeader\`**:
   - *Tokens*: Title: \`AppTextStyles.title\`, Action: \`AppButton.ghost\`, Padding: \`AppSpacing.insetHorizontalLg\`.
5. **\`AppIconTile\`**:
   - *Tokens*: Leading icon in neutral container, Title: \`AppTextStyles.titleSmall\`, Border: \`AppBorders.regular\`, Surface: \`AppColors.surface\`.
6. **\`AppEmptyState\`**:
   - *Tokens*: Illustration: SVG/vector mascot, Title: \`AppTextStyles.title\`, Description: \`AppTextStyles.body\`, Primary Action: \`AppButton\`.
7. **\`AppToast\`**:
   - *Tokens*: Surface: \`AppColors.textPrimary\`, Text: \`AppColors.white\`, Elevation: \`AppElevation.shadowLg\`, Radius: \`AppRadius.borderPill\`.

---

## A3. WCAG 2.2 AA Accessibility Audit

### A3.1 Contrast Audit
> **Script Command**: \`node tools/audit/audit_a3_contrast.js\`  
> **Thresholds**: Normal Text $\\ge$ 4.5:1, Large Text ($\\ge$24px or $\\ge$18.66px Bold) $\\ge$ 3.0:1, UI Components/Borders $\\ge$ 3.0:1.

| Color Pair | Contrast Ratio | WCAG 2.2 Status | Where Used in App | Issue & Fix Recommendation |
| :--- | :---: | :---: | :--- | :--- |
| **White on Brand Primary (0xFF58CC02)** | **2.09:1** | ❌ **FAIL** (Threshold 4.5:1 / 3.0:1) | Primary \`AppButton\`, \`DuolingoButton\`, Badges | **Critical Failure**. Use \`textPrimary\` (#0F172A) on brand green (8.55:1), or darken brand green to #2E7D32 for white text. |
| **\`textPrimary\` on Brand Primary** | **8.55:1** | ✅ **PASS (AAA)** | Proposed Accessible Button Pattern | Highly recommended for all child buttons. |
| **White on Brand Dark (0xFF46A302)** | **3.23:1** | ⚠️ **PASS Large only** (Fail Normal) | 3D bevels, Header titles | Use dark text or large bold text only. |
| **Darker Green (0xFF2E7D32) on White** | **5.13:1** | ✅ **PASS (AA Normal)** | Proposed Option B Brand Green | Meets full WCAG AA normal text requirements with white. |
| **White on Orange (0xFFFF9600)** | **2.18:1** | ❌ **FAIL** (< 3.0) | Streak badge, mission buttons | Use dark text \`textPrimary\` or \`orangeDark\` background. |
| **White on Accent Gold (0xFFFFC800)** | **1.55:1** | ❌ **FAIL** (< 3.0) | XP / Star coins pill | Replace text color with \`AppColors.textPrimary\` (11.49:1 ratio). |
| **\`textPrimary\` on Accent Gold** | **11.49:1** | ✅ **PASS (AAA)** | Star / Coin / Level badges | Perfect contrast. |
| **White on Blue (0xFF1CB0F6)** | **2.44:1** | ❌ **FAIL** (< 3.0) | Info pills, audio buttons | Replace white text with \`AppColors.textPrimary\`. |
| **\`textTertiary\` (0xFF94A3B8) on White** | **2.56:1** | ❌ **FAIL** (< 4.5) | Captions, subtitle footers | Upgrade subtle captions to \`AppColors.textSecondary\` (7.58:1). |
| **\`textDisabled\` (0xFFCBD5E1) on White** | **1.48:1** | ❌ **FAIL** (< 4.5) | Locked lessons, disabled actions | Provide secondary icon indicator (lock icon) so text color is not sole signifier. |
| **\`greenText\` on \`greenLight\` (Success)** | **4.57:1** | ✅ **PASS (AA Normal)** | Success alerts, completed steps | Compliant. |
| **\`textBrand\` on \`brandLight\`** | **5.94:1** | ✅ **PASS (AA Normal)** | Active salah card, prayer times | Compliant. |
| **\`orangeText\` on \`orangeLight\`** | **4.52:1** | ✅ **PASS (AA Normal)** | Dua categories | Compliant. |
| **\`blueText\` on \`blueLight\`** | **5.84:1** | ✅ **PASS (AA Normal)** | Quran audio cards | Compliant. |
| **\`purpleText\` on \`purpleLight\`** | **5.92:1** | ✅ **PASS (AA Normal)** | Seerah stories | Compliant. |
| **\`warningText\` on \`warningLight\`** | **6.37:1** | ✅ **PASS (AA Normal)** | Admin banner | Compliant. |
| **Border (Slate 200) on White Surface** | **1.23:1** | ⚠️ Low border contrast | Card boundaries | For accessibility, card surface separation is reinforced by elevation shadow or Slate 300 (\`borderStrong\`). |

---

### A3.2 Touch Target Audit
> **Script Command**: \`node tools/audit/audit_a3_semantics_targets.js\`  
> - **WCAG 2.5.8 Minimum AA Threshold**: 24x24 px  
> - **Apple / Android Child-Accessible Recommendation**: 44x44 px (or 48x48 px)

- **Tappables smaller than 24x24 (Strict WCAG 2.5.8 AA Failures)**: 0
- **Tappables smaller than 44x44 (Child Usability Failures)**: 4 detected
  1. \`lib/widgets/duolingo_appbar.dart:143\`: Header back button Container \`width: 38, height: 38\` (inside InkWell).
  2. \`lib/screens/qaida/qaida_chapters_screen.dart:581\`: Header progress badge \`height: 28\`.
  3. \`lib/screens/home/home_screen.dart:148\`: Student mode button in Admin Banner \`height: ~24\`.
  4. \`lib/widgets/faceless_silhouette.dart:296\`: Avatar selector item \`size: 38\`.

---

### A3.3 Semantics & Accessibility Audit
> **Script Command**: \`node tools/audit/audit_a3_semantics_targets.js\`

- **Unlabeled Icon Buttons**: 9 occurrences (missing \`tooltip\` and \`Semantics(label: ...)\`).
  - \`lib/screens/prayer/prayer_screen.dart:1153, 1157\`
  - \`lib/screens/profile/login_screen.dart:75\` (password visibility toggle)
  - \`lib/screens/qaida/qaida_activity_screen.dart:927\`
  - \`lib/screens/quran/quran_screen.dart:163, 432\`
  - \`lib/widgets/ds/app_top_bar.dart:84\`
  - \`lib/widgets/language_switcher.dart:147, 161\`
- **Images Missing Semantics**: 14 occurrences (neither \`semanticLabel\` nor \`excludeFromSemantics: true\`).
- **TextFields Missing Accessible Labels**: 1 occurrence (\`lib/screens/onboarding/name_age_page.dart:199\`).
- **Animations Lacking Reduced Motion**: 6 animation controllers run continuously without checking \`MediaQuery.of(context).disableAnimations\`.

---

### A3.4 Text Scaling & Layout Overflow Reproduction Test
> **Test Command**: \`flutter test test/text_scaling_audit_test.dart\`

#### Verified Reproduction: Italian Admin Banner Cramping & Overflow
In Italian (\`it\`), \`home.admin_mode_notice\` translates to **"Modalità amministratore: tutti i livelli sbloccati"** and the button text is **"Modalità studente"**.
On a 360px screen at \`textScale: 1.5\`:
\`\`\`
--- Italian Admin Banner Metrics at scale 1.5 ---
Admin Notice Text Size: Size(0.0, 990.0)
Student Mode Button Size: Size(284.8, 20.0)
Total Row constraint width: 360 - 32 = 328px
Remaining width for notice: 328 - 284.75 = 43.25px
══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════════════════════════════════════
A RenderFlex overflowed by 35 pixels on the right.
The relevant error-causing widget was:
  Row:file:///Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart:133:28
\`\`\`
**Root Cause**: A rigid horizontal \`Row\` with \`Expanded\` text and an inflexible button child. At 1.5x scale, the button expands to 285px wide, starving the label and blowing past the screen bounds.  
**Fix**: Convert banner to a flex column on narrow screens or wrap in an accessible \`AppBanner\` component with \`Wrap\` or vertical button layout.

---

## A4. Heuristic Evaluation (Nielsen's 10 + Child-App Concerns)

### Evaluated Screens
1. **Home Screen** (\`HomeScreen\`)
2. **Qaida Chapters Screen** (\`QaidaChaptersScreen\`)
3. **Qaida Lesson Screen** (\`QaidaLessonScreen\`)
4. **Quran Reader / Screen** (\`QuranScreen\`, \`QuranReaderScreen\`)
5. **Settings Screen** (\`SettingsScreen\`)
6. **Profile / Login Screen** (\`ProfileScreen\`, \`LoginScreen\`)

#### Screenshots Rendered at 360px Width (Real Fonts)
Evidence screenshots captured under \`docs/screenshots/audit/\`:
- Home: \`docs/screenshots/audit/home_360_en.png\`, \`home_360_hi.png\`, \`home_360_it.png\`
- Qaida Chapters: \`docs/screenshots/audit/qaida_chapters_360_en.png\`, \`qaida_chapters_360_hi.png\`, \`qaida_chapters_360_it.png\`
- Qaida Lesson: \`docs/screenshots/audit/qaida_lesson_360_en.png\`, \`qaida_lesson_360_hi.png\`, \`qaida_lesson_360_it.png\`
- Quran Screen: \`docs/screenshots/audit/quran_360_en.png\`, \`quran_360_hi.png\`, \`quran_360_it.png\`
- Quran Reader: \`docs/screenshots/audit/quran_reader_360_en.png\`, \`quran_reader_360_hi.png\`, \`quran_reader_360_it.png\`
- Settings: \`docs/screenshots/audit/settings_360_en.png\`, \`settings_360_hi.png\`, \`settings_360_it.png\`
- Profile: \`docs/screenshots/audit/profile_360_en.png\`, \`profile_360_hi.png\`, \`profile_360_it.png\`

*Verification Note regarding Fonts*: \`assets/fonts/\` only contains \`Amiri-Regular.ttf\` and \`Amiri-Bold.ttf\`. Noto Sans Bengali, Noto Sans Devanagari, and Inter are loaded dynamically at runtime via \`google_fonts\`. During automated offline tests, system fallbacks (Roboto / Arial Unicode) are utilized to ensure distinct glyph rendering without modifying repo assets.

### Heuristic Findings Matrix
| # | Nielsen Heuristic / Child Concern | Screen | Severity (0-4) | Evidence (file:line / screenshot) | Finding & Recommendation |
| :-: | :--- | :--- | :-: | :--- | :--- |
| **1** | **Child Concern: Parental Gate** | Home / Settings | **4 (Critical)** | \`home_screen.dart:144\` | **Zero Parental Gate on Admin Mode**: Any 6-year-old child can tap the Admin Mode button or access settings and toggle unlocked levels. *Recommendation*: Add a math multiplication challenge or parental PIN dialog before unlocking admin mode or resetting progress. |
| **2** | **Child Concern: Cognitive Load** | Home | **3 (Major)** | \`home_screen.dart:125-450\` | **Too Many Competing Visual Elements**: Home displays an Admin banner, Noor mascot speech card, streak banner, live class banner, and 4 colored cards simultaneously. *Recommendation*: Collapse secondary banners into dismissible pills; use clean white cards with single neutral borders. |
| **3** | **Consistency & Standards** | Qaida Chapters | **3 (Major)** | \`qaida_chapters_screen.dart:555\` | **Mismatched Header**: Uses legacy \`DuolingoPageHeader\` with green gradient and bubble accents instead of \`AppTopBar.page\`. *Recommendation*: Replace with \`AppTopBar.page\`. |
| **4** | **Consistency & Standards** | Qaida Chapters | **3 (Major)** | \`qaida_chapters_screen.dart:158,239,320,395\` | **Tinted-Card Anti-Pattern**: 4 cards have 4 distinct border colors (indigo, green, amber, purple). *Recommendation*: Standardize to white surface with \`AppStroke.regular\` neutral border; keep color only on step icons. |
| **5** | **Error Prevention & Recovery** | Qaida Lesson | **2 (Medium)** | \`qaida_lesson_screen.dart:340\` | **Harsh Fail Feedback on Mistake**: Wrong letter selection triggers red buzzer without giving child an immediate second hint. *Recommendation*: Provide gentle encouraging audio ("Try again!") and keep attempts friendly. |
| **6** | **Child Concern: Tap Target Size** | All screens | **3 (Major)** | \`duolingo_appbar.dart:143\` | **Sub-44px Back Button**: The back button on legacy headers is 38x38px, causing miss-taps for young children. *Recommendation*: Enforce minimum 48x48px hit box across all buttons. |
| **7** | **Aesthetic & Minimalist Design** | Qaida Chapters | **2 (Medium)** | \`garden_progress_widget.dart:259\` | **Multi-Gradient Garden Scene**: Uses 3 nested linear gradients conflicting with the flat Duolingo aesthetic. *Recommendation*: Flatten background hills to solid fills with clean SVG vectors. |
| **8** | **Visibility of System Status** | Quran Reader | **2 (Medium)** | \`quran_reader_screen.dart:34\` | **Ambiguous Audio Buffering**: When switching ayahs, no tactile indicator shows that audio is streaming until sound plays. *Recommendation*: Add visual loading spinner in the audio playback bar. |
| **9** | **User Control & Freedom** | Quran Screen | **2 (Medium)** | \`quran_screen.dart:880\` | **No Quick Return to Last Read**: When browsing 114 surahs, the child has to scroll all the way down without a "Resume Surah" floating action button. *Recommendation*: Add top "Continue Reading" banner. |
| **10** | **Recognition vs Recall** | Settings | **1 (Minor)** | \`settings_screen.dart:39-120\` | **Dense List of Toggles**: Settings uses standard Material ListTile toggles that feel like an adult OS setting rather than a playful child interface. *Recommendation*: Use card-based \`AppSwitchTile\` with friendly Islamic icons. |

---

## A5. Prioritized Action Plan & Effort Estimation

| Priority | Category | Task | Affected Files | Effort (Hours) |
| :---: | :---: | :--- | :--- | :---: |
| **P0** | **A11y & Bug** | Fix Italian Admin Banner text overflow at $\\ge$1.5x scale | \`lib/screens/home/home_screen.dart\` | 1.5h |
| **P0** | **A11y** | Resolve Brand Green contrast failure (White on 0xFF58CC02 is 2.09:1) | \`lib/theme/app_colors.dart\`, \`lib/widgets/ds/app_button.dart\` | 2.0h |
| **P0** | **Safety** | Implement Parental Gate modal for Admin & Settings | New DS Component \`AppParentalGate\` | 2.5h |
| **P1** | **Consistency** | Migrate \`QaidaChaptersScreen\` to \`AppTopBar.page\` & neutral card borders | \`lib/screens/qaida/qaida_chapters_screen.dart\` | 3.0h |
| **P1** | **Consistency** | Retire legacy \`DuolingoHeader\` / \`DuolingoPageHeader\` / \`_HeaderBubble\` | \`lib/widgets/duolingo_appbar.dart\` | 2.0h |
| **P1** | **Design Gate** | Introduce missing DS components: \`AppTextField\`, \`AppSwitchTile\`, \`AppBanner\` | \`lib/widgets/ds/\` | 4.0h |
| **P1** | **Consistency** | Migrate remaining screens (\`Prayer\`, \`Duas\`, \`Seerah\`, \`Basics\`, \`Missions\`) to \`AppTopBar.page\` | \`lib/screens/**\` | 5.0h |
| **P2** | **Polish** | Enforce $\\ge$44x44 touch targets on all interactive icon buttons | Entire codebase | 2.0h |
| **P2** | **A11y** | Add \`MediaQuery.disableAnimations\` checks to 6 animation controllers | 6 files identified in audit | 1.5h |
| **P2** | **A11y** | Add missing semantics labels & tooltips to 9 icon buttons and 14 images | Various screens | 2.0h |
`;

fs.writeFileSync(OUT_DOC, md);
console.log(`Successfully generated ${OUT_DOC}`);
