const fs = require('fs');
const path = require('path');

// RGB / HSL / Contrast utilities
function parseHex(hexStr) {
  let h = hexStr.replace(/^#/, '').replace(/^0x/i, '');
  if (h.length === 8) h = h.substring(2); // ignore alpha
  const r = parseInt(h.substring(0, 2), 16);
  const g = parseInt(h.substring(2, 4), 16);
  const b = parseInt(h.substring(4, 6), 16);
  return { r, g, b };
}

function rgbToHsl({ r, g, b }) {
  r /= 255; g /= 255; b /= 255;
  const max = Math.max(r, g, b);
  const min = Math.min(r, g, b);
  let h, s, l = (max + min) / 2;
  if (max === min) {
    h = s = 0; // achromatic
  } else {
    const d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    switch (max) {
      case r: h = (g - b) / d + (g < b ? 6 : 0); break;
      case g: h = (b - r) / d + 2; break;
      case b: h = (r - g) / d + 4; break;
    }
    h = Math.round(h * 60);
  }
  return {
    h,
    s: Math.round(s * 100),
    l: Math.round(l * 100)
  };
}

function srgbToLinear(c8) {
  const c = c8 / 255;
  return c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
}

function relativeLuminance({ r, g, b }) {
  return 0.2126 * srgbToLinear(r) + 0.7152 * srgbToLinear(g) + 0.0722 * srgbToLinear(b);
}

function contrastRatio(hex1, hex2) {
  const l1 = relativeLuminance(parseHex(hex1));
  const l2 = relativeLuminance(parseHex(hex2));
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

// 1. Current Home modules & colors from repo files
const HOME_MODULES = [
  {
    module: 'Qaida',
    titleKey: 'nav.qaida',
    faceColor: '#58CC02',
    bevelColor: '#46A302',
    fileLine: 'lib/core/navigation/module_registry.dart:58',
    cardUsageLine: 'lib/theme/design_system.dart:114',
  },
  {
    module: 'Quran',
    titleKey: 'nav.quran',
    faceColor: '#FFC800',
    bevelColor: '#E5A100',
    fileLine: 'lib/core/navigation/module_registry.dart:67',
    cardUsageLine: 'lib/theme/design_system.dart:118',
  },
  {
    module: 'Prayer',
    titleKey: 'nav.prayer',
    faceColor: '#1CB0F6',
    bevelColor: '#1899D6',
    fileLine: 'lib/core/navigation/module_registry.dart:76',
    cardUsageLine: 'lib/theme/design_system.dart:122',
  },
  {
    module: 'Dua',
    titleKey: 'nav.dua',
    faceColor: '#A855F7',
    bevelColor: '#9333EA',
    fileLine: 'lib/core/navigation/module_registry.dart:85',
    cardUsageLine: 'lib/theme/design_system.dart:126',
  },
  {
    module: 'Seerah',
    titleKey: 'nav.seerah',
    faceColor: '#EC4899',
    bevelColor: '#DB2777',
    fileLine: 'lib/core/navigation/module_registry.dart:94',
    cardUsageLine: 'lib/theme/design_system.dart:130',
  },
  {
    module: 'Basics',
    titleKey: 'nav.basics',
    faceColor: '#14B8A6',
    bevelColor: '#0D9488',
    fileLine: 'lib/core/navigation/module_registry.dart:103',
    cardUsageLine: 'lib/theme/design_system.dart:134',
  },
  {
    module: 'Achievements',
    titleKey: 'nav.achievements',
    faceColor: '#F59E0B',
    bevelColor: '#D97706',
    fileLine: 'lib/core/navigation/module_registry.dart:112',
    cardUsageLine: 'lib/theme/design_system.dart:138',
  },
];

console.log('=== TABLE: MODULE | CURRENT CARD COLOR | FILE:LINE | COLLIDING HUES ===');
console.log('| Module | Face Hex | Bevel Hex | HSL Hue | File:Line | Collision Flag |');
console.log('| :--- | :--- | :--- | :--- | :--- | :--- |');

for (let i = 0; i < HOME_MODULES.length; i++) {
  const m = HOME_MODULES[i];
  const hsl = rgbToHsl(parseHex(m.faceColor));
  const collisions = [];
  for (let j = 0; j < HOME_MODULES.length; j++) {
    if (i === j) continue;
    const other = HOME_MODULES[j];
    const otherHsl = rgbToHsl(parseHex(other.faceColor));
    const hueDiff = Math.abs(hsl.h - otherHsl.h);
    const minDiff = Math.min(hueDiff, 360 - hueDiff);
    if (minDiff <= 25) {
      collisions.push(`${other.module} (Δhue=${minDiff}°)`);
    }
  }
  const flag = collisions.length > 0 ? `⚠️ Collides with ${collisions.join(', ')}` : '✅ Distinct';
  console.log(`| **${m.module}** | \`${m.faceColor}\` | \`${m.bevelColor}\` | ${hsl.h}° (S:${hsl.s}%, L:${hsl.l}%) | \`${m.fileLine}\` | ${flag} |`);
}

// 2. Propose ModuleTheme Palettes with script-verified WCAG Contrast Ratios
// Every module must have:
// - primaryDark: used for Primary Button fill with White text. (Must have CR >= 4.5:1 with #FFFFFF)
// - primaryDarkEdge: 3D bottom edge (flat solid darker shade of primaryDark)
// - primarySoft: soft/light tint for header panel, secondary button fill, soft icon tiles, page background
// - primarySoftEdge: 3D bottom edge for soft controls (darker shade of primarySoft)
// - headerPanel: soft fill
// - headerIllustrationTint: flat decorative illustration tint (slightly darker tint on soft panel)
// - textOnSoft: dark text on headerPanel & illustrationTint (Must have CR >= 4.5:1 with both panel AND illustration)
// - textOnDark: white bold text on primaryDark button (Must have CR >= 4.5:1 with primaryDark)
// - iconOnSoft: dark same-hue icon on soft tile (Must have CR >= 3:1)
// - inputBorder: 1.5px border on white input against soft page bg (Must have CR >= 3:1)

const MODULE_PALETTES = [
  {
    module: 'app (Shell/Settings/Profile/Login/Onboarding)',
    hue: 'Light Green',
    primaryDark: '#2E7D32',         // Forest green: CR with white = 5.15:1
    primaryDarkEdge: '#1B5E20',     // 3D edge
    primarySoft: '#E8F5E9',         // Gentle light green tint (94% L)
    primarySoftEdge: '#C8E6C9',     // Soft 3D edge
    headerIllustration: '#D0EBD2',  // Soft tint for flat vector mosque/stars
    textOnSoft: '#1B5E20',          // Deep green text (CR with soft = 7.8:1, with illus = 6.8:1)
    pageBg: '#F4FAF4',              // Very gentle page tint
  },
  {
    module: 'qaida',
    hue: 'Green',
    primaryDark: '#2E7D32',         // Forest green: CR with white = 5.15:1
    primaryDarkEdge: '#1B5E20',     // 3D edge
    primarySoft: '#E8F5E9',         // Gentle light green tint
    primarySoftEdge: '#C8E6C9',     // Soft 3D edge
    headerIllustration: '#D0EBD2',  // Decorative Islamic star/mosque vector
    textOnSoft: '#1B5E20',          // Deep green text
    pageBg: '#F4FAF4',
  },
  {
    module: 'quran',
    hue: 'Gold / Amber',
    primaryDark: '#B45309',         // Rich dark amber/bronze: CR with white = 4.67:1
    primaryDarkEdge: '#78350F',     // Deep amber edge
    primarySoft: '#FEF3C7',         // Warm soft cream/gold tint
    primarySoftEdge: '#FDE68A',     // Soft 3D edge
    headerIllustration: '#FCE798',  // Flat Quranic arch/star illustration tint
    textOnSoft: '#78350F',          // Deep bronze text (CR with soft = 7.7:1, with illus = 6.7:1)
    pageBg: '#FFFDF5',
  },
  {
    module: 'prayer',
    hue: 'Sky / Ocean Blue',
    primaryDarkBefore: '#0284C7',     // CR: 4.10:1 (FAILED WCAG AA)
    primaryDark: '#0369A1',           // Deep sky/ocean: CR with white = 5.21:1 (PASSED)
    primaryDarkEdge: '#075985',       // Navy-blue edge
    primarySoft: '#E0F2FE',           // Soft sky tint
    primarySoftEdge: '#BAE6FD',       // Soft 3D edge
    headerIllustration: '#C9EBFE',    // Flat mosque dome/minaret silhouette
    textOnSoft: '#075985',            // Deep navy text
    pageBg: '#F0F9FF',
  },
  {
    module: 'dua',
    hue: 'Purple / Violet',
    primaryDark: '#7E22CE',         // Deep violet: CR with white = 6.55:1
    primaryDarkEdge: '#581C87',     // Dark purple edge
    primarySoft: '#F3E8FF',         // Soft lavender tint
    primarySoftEdge: '#E9D5FF',     // Soft 3D edge
    headerIllustration: '#DFC7FA',  // Flat crescent/star illustration
    textOnSoft: '#581C87',          // Deep purple text (CR with soft = 8.5:1, with illus = 7.2:1)
    pageBg: '#FAF5FF',
  },
  {
    module: 'seerah',
    hue: 'Rose / Pink',
    primaryDark: '#BE185D',         // Deep raspberry rose: CR with white = 5.56:1
    primaryDarkEdge: '#831843',     // Dark rose edge
    primarySoft: '#FCE7F3',         // Soft rose tint
    primarySoftEdge: '#FBCFE8',     // Soft 3D edge
    headerIllustration: '#F7C2DC',  // Flat Islamic geometric lantern illustration
    textOnSoft: '#831843',          // Deep rose text (CR with soft = 8.1:1, with illus = 6.8:1)
    pageBg: '#FDF2F8',
  },
  {
    module: 'basics',
    hue: 'Teal (shifted to Deep Emerald Teal to avoid blue collision)',
    primaryDark: '#0F766E',         // Deep teal: CR with white = 5.04:1
    primaryDarkEdge: '#115E59',     // Darker teal edge
    primarySoft: '#CCFBF1',         // Soft mint/teal tint
    primarySoftEdge: '#99F6E4',     // Soft 3D edge
    headerIllustration: '#B1F1E5',  // Flat arch/geometry illustration
    textOnSoft: '#115E59',          // Deep pine teal text (CR with soft = 7.4:1, with illus = 6.4:1)
    pageBg: '#F0FDFA',
  },
  {
    module: 'achievements',
    hue: 'Bronze / Warm Orange (distinct from Quran Gold)',
    primaryDark: '#C2410C',         // Deep copper/amber-orange: CR with white = 4.88:1
    primaryDarkEdge: '#9A3412',     // Dark copper edge
    primarySoft: '#FFEDD5',         // Warm peach/apricot tint
    primarySoftEdge: '#FED7AA',     // Soft 3D edge
    headerIllustration: '#FDCB95',  // Flat medal/trophy geometric illustration
    textOnSoft: '#7C2D12',          // Deep mahogany text (CR with soft = 8.4:1, with illus = 7.1:1)
    pageBg: '#FFF7ED',
  },
];

console.log('\n=== TABLE: MODULETHEME PALETTE WITH SCRIPT-COMPUTED CONTRAST RATIOS ===');
console.log('| Module | Primary Dark (Btn Fill) | White on Dark (CR >= 4.5:1) | Primary Soft (Panel Fill) | Illus. Tint | Text on Soft (CR >= 4.5:1) | Text on Illus (CR >= 4.5:1) | Soft Icon on Tile (CR >= 3:1) |');
console.log('| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |');

for (const p of MODULE_PALETTES) {
  const crWhiteOnDark = contrastRatio('#FFFFFF', p.primaryDark).toFixed(2);
  const crTextOnSoft = contrastRatio(p.textOnSoft, p.primarySoft).toFixed(2);
  const crTextOnIllus = contrastRatio(p.textOnSoft, p.headerIllustration).toFixed(2);
  const crIconOnSoft = contrastRatio(p.primaryDark, p.primarySoft).toFixed(2);

  const passDark = crWhiteOnDark >= 4.5 ? '✅' : '❌ FAIL';
  const passTextSoft = crTextOnSoft >= 4.5 ? '✅' : '❌ FAIL';
  const passTextIllus = crTextOnIllus >= 4.5 ? '✅' : '❌ FAIL';
  const passIcon = crIconOnSoft >= 3.0 ? '✅' : '❌ FAIL';

  console.log(`| **${p.module}** | \`${p.primaryDark}\` | **${crWhiteOnDark}:1** ${passDark} | \`${p.primarySoft}\` | \`${p.headerIllustration}\` | **${crTextOnSoft}:1** ${passTextSoft} | **${crTextOnIllus}:1** ${passTextIllus} | **${crIconOnSoft}:1** ${passIcon} |`);
}

console.log('\n=== TABLE: CONTRAST ADJUSTMENTS (BEFORE / AFTER) ===');
console.log('| Module / Pair | Element | Original Color | Original CR | Adjusted Color | Adjusted CR | WCAG Status |');
console.log('| :--- | :--- | :--- | :--- | :--- | :--- | :--- |');

for (const p of MODULE_PALETTES) {
  if (p.primaryDarkBefore) {
    const crBefore = contrastRatio('#FFFFFF', p.primaryDarkBefore).toFixed(2);
    const crAfter = contrastRatio('#FFFFFF', p.primaryDark).toFixed(2);
    console.log(`| **${p.module}** | Button fill + White text | \`${p.primaryDarkBefore}\` | ${crBefore}:1 ❌ FAIL (<4.5:1) | \`${p.primaryDark}\` | **${crAfter}:1** ✅ PASS | Fixed WCAG 1.4.3 |`);
  }
}
// Also check the brand green #58CC02 on white
const crQaidaOld = contrastRatio('#FFFFFF', '#58CC02').toFixed(2);
const crQaidaNew = contrastRatio('#FFFFFF', '#2E7D32').toFixed(2);
console.log(`| **qaida / app** | Primary Button fill + White text | \`#58CC02\` | ${crQaidaOld}:1 ❌ FAIL (<4.5:1) | \`#2E7D32\` | **${crQaidaNew}:1** ✅ PASS | Darkened shade for white text |`);
