// WCAG 2.2 Relative Luminance and Contrast Ratio Calculator

function parseColor(hexOrInt) {
  if (typeof hexOrInt === 'number') {
    const a = (hexOrInt >> 24) & 0xFF;
    const r = (hexOrInt >> 16) & 0xFF;
    const g = (hexOrInt >> 8) & 0xFF;
    const b = hexOrInt & 0xFF;
    return { r, g, b, a };
  }
  let hex = hexOrInt.replace(/^#/, '').replace(/^0x/i, '');
  if (hex.length === 8) {
    hex = hex.substring(2); // drop alpha if hex
  }
  const r = parseInt(hex.substring(0, 2), 16);
  const g = parseInt(hex.substring(2, 4), 16);
  const b = parseInt(hex.substring(4, 6), 16);
  return { r, g, b, a: 255 };
}

function srgbToLinear(c8) {
  const c = c8 / 255;
  return c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
}

function relativeLuminance(rgb) {
  const r = srgbToLinear(rgb.r);
  const g = srgbToLinear(rgb.g);
  const b = srgbToLinear(rgb.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

function contrastRatio(color1, color2) {
  const l1 = relativeLuminance(parseColor(color1));
  const l2 = relativeLuminance(parseColor(color2));
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

// Color tokens used in Little Muslim
const COLORS = {
  // Brand
  brandPrimary: 0xFF58CC02,
  brandDark: 0xFF46A302,
  brandLight: 0xFFE8F8D8,
  brandAccent: 0xFFFFC800,
  brandAccentDark: 0xFFE5A100,
  textBrand: 0xFF2D6A00,
  
  // Neutrals / Text
  white: 0xFFFFFFFF,
  black: 0xFF000000,
  textPrimary: 0xFF0F172A,
  textSecondary: 0xFF475569,
  textTertiary: 0xFF94A3B8,
  textDisabled: 0xFFCBD5E1,
  
  // Surfaces & Borders
  surface: 0xFFFFFFFF,
  surfaceSubtle: 0xFFF1F5F9,
  slate50: 0xFFF8FAFC,
  slate100: 0xFFF1F5F9,
  slate200: 0xFFE2E8F0,
  slate300: 0xFFCBD5E1,
  border: 0xFFE2E8F0,
  borderStrong: 0xFFCBD5E1,
  borderBrand: 0xFF86EFAC,
  
  // Secondary Accents
  blue: 0xFF1CB0F6,
  blueDark: 0xFF1899D6,
  blueLight: 0xFFE0F2FE,
  blueText: 0xFF1D4ED8,
  
  purple: 0xFF8B5CF6,
  purpleDark: 0xFF7C3AED,
  purpleLight: 0xFFF3E8FF,
  purpleText: 0xFF7E22CE,
  purpleBorder: 0xFFE9D5FF,
  
  orange: 0xFFFF9600,
  orangeDark: 0xFFEA8000,
  orangeLight: 0xFFFFEDD5,
  orangeText: 0xFFC2410C,
  orangeBorder: 0xFFFDBA74,

  // Feedback
  success: 0xFF16A34A,
  successLight: 0xFFDCFCE7,
  successBorder: 0xFF86EFAC,
  greenText: 0xFF15803D,
  
  warning: 0xFFF59E0B,
  warningLight: 0xFFFEF3C7,
  warningBorder: 0xFFFDE68A,
  warningText: 0xFF92400E,
  warningSubtext: 0xFFB45309,
  
  error: 0xFFEF4444,
  errorLight: 0xFFFEE2E2,
  errorBorder: 0xFFFCA5A5,

  info: 0xFF3B82F6,
  infoLight: 0xFFEFF6FF,
  infoBorder: 0xFFBFDBFE,
};

// Pairs to evaluate across the app
const PAIRS = [
  // 1. Brand primary combinations
  { name: 'White on BrandPrimary (0xFF58CC02)', fg: 'white', bg: 'brandPrimary', type: 'text', where: 'Buttons (AppButton primary, DuolingoButton), Badges, Headers' },
  { name: 'textPrimary on BrandPrimary', fg: 'textPrimary', bg: 'brandPrimary', type: 'text', where: 'Proposed alternative for brandPrimary buttons' },
  { name: 'textBrand on BrandPrimary', fg: 'textBrand', bg: 'brandPrimary', type: 'text', where: 'Brand text on brand primary fill' },
  { name: 'White on BrandDark (0xFF46A302)', fg: 'white', bg: 'brandDark', type: 'text', where: '3D button bevels, dark brand headers' },
  { name: 'Darker Brand Green (0xFF2E7D32) with White', fg: 'white', bg: 0xFF2E7D32, type: 'text', where: 'Proposed Option B accessible brand green' },

  // 2. Accents & Chips (white on color)
  { name: 'White on Orange (0xFFFF9600)', fg: 'white', bg: 'orange', type: 'text', where: 'Streak badges, orange action chips, mission buttons' },
  { name: 'White on OrangeDark (0xFFEA8000)', fg: 'white', bg: 'orangeDark', type: 'text', where: 'Orange button bevels/chips' },
  { name: 'White on BrandAccent Yellow (0xFFFFC800)', fg: 'white', bg: 'brandAccent', type: 'text', where: 'XP / Coin / Star badges, gold chips' },
  { name: 'textPrimary on BrandAccent Yellow', fg: 'textPrimary', bg: 'brandAccent', type: 'text', where: 'Gold badge labels with dark text' },
  { name: 'White on Blue (0xFF1CB0F6)', fg: 'white', bg: 'blue', type: 'text', where: 'Blue action buttons, info chips, bookmarks' },
  { name: 'White on Purple (0xFF8B5CF6)', fg: 'white', bg: 'purple', type: 'text', where: 'Seerah/Dua chapter chips, purple buttons' },

  // 3. Text on Surfaces
  { name: 'textPrimary on Surface (White)', fg: 'textPrimary', bg: 'white', type: 'text', where: 'Main body, titles, headings on white cards' },
  { name: 'textSecondary on Surface (White)', fg: 'textSecondary', bg: 'white', type: 'text', where: 'Subtitles, descriptions, secondary copy' },
  { name: 'textTertiary (Grey caption) on Surface', fg: 'textTertiary', bg: 'white', type: 'text', where: 'Footers, timestamps, subtle captions' },
  { name: 'textDisabled on Surface', fg: 'textDisabled', bg: 'white', type: 'text', where: 'Disabled buttons, locked chapter text' },
  { name: 'textSecondary on surfaceSubtle (0xFFF1F5F9)', fg: 'textSecondary', bg: 'surfaceSubtle', type: 'text', where: 'Section headers, subtle card surfaces' },
  { name: 'textTertiary on surfaceSubtle', fg: 'textTertiary', bg: 'surfaceSubtle', type: 'text', where: 'Captions on subtle backgrounds' },

  // 4. Text on Tinted Cards
  { name: 'greenText on greenLight (Success)', fg: 'greenText', bg: 'successLight', type: 'text', where: 'Completed chapter cards, success banners' },
  { name: 'textBrand on brandLight', fg: 'textBrand', bg: 'brandLight', type: 'text', where: 'Prayer time active cards, Salah badge' },
  { name: 'orangeText on orangeLight', fg: 'orangeText', bg: 'orangeLight', type: 'text', where: 'Duas category card, streak reminder banner' },
  { name: 'blueText on blueLight', fg: 'blueText', bg: 'blueLight', type: 'text', where: 'Quran chapter card, audio player card' },
  { name: 'purpleText on purpleLight', fg: 'purpleText', bg: 'purpleLight', type: 'text', where: 'Seerah stories card, revision card' },
  { name: 'warningText on warningLight', fg: 'warningText', bg: 'warningLight', type: 'text', where: 'Admin mode banner, daily mission alert' },
  { name: 'warningSubtext on warningLight', fg: 'warningSubtext', bg: 'warningLight', type: 'text', where: 'Admin mode secondary text' },

  // 5. Borders & UI Components on Background
  { name: 'border (Slate 200) on Surface (White)', fg: 'border', bg: 'white', type: 'ui', where: 'AppCard border, AppListTile divider, input borders' },
  { name: 'borderStrong (Slate 300) on Surface', fg: 'borderStrong', bg: 'white', type: 'ui', where: 'Selected card borders, high-contrast inputs' },
  { name: 'borderBrand on Surface', fg: 'borderBrand', bg: 'white', type: 'ui', where: 'Active step borders, green pill borders' },
  { name: 'orangeBorder on Surface', fg: 'orangeBorder', bg: 'white', type: 'ui', where: 'Orange card borders' },
  { name: 'purpleBorder on Surface', fg: 'purpleBorder', bg: 'white', type: 'ui', where: 'Purple card borders' },
  { name: 'infoBorder on Surface', fg: 'infoBorder', bg: 'white', type: 'ui', where: 'Blue card borders' },
];

const results = PAIRS.map(p => {
  const fgVal = typeof p.fg === 'number' ? p.fg : COLORS[p.fg];
  const bgVal = typeof p.bg === 'number' ? p.bg : COLORS[p.bg];
  const ratio = contrastRatio(fgVal, bgVal);
  const rounded = Math.round(ratio * 100) / 100;
  
  // Normal text requirement: 4.5:1
  // Large text requirement: 3.0:1
  // UI component / border requirement: 3.0:1
  let passNormal = rounded >= 4.5;
  let passLarge = rounded >= 3.0;
  let passUi = rounded >= 3.0;

  let status = '';
  if (p.type === 'ui') {
    status = passUi ? 'PASS (UI >=3.0)' : 'FAIL (< 3.0)';
  } else {
    if (passNormal) status = 'PASS (AA Normal >=4.5)';
    else if (passLarge) status = 'PASS Large only (>=3.0, FAIL Normal)';
    else status = 'FAIL (< 3.0)';
  }

  return {
    'Token Pair': p.name,
    'Contrast Ratio': `${rounded}:1`,
    'WCAG 2.2 Status': status,
    'Where Used': p.where
  };
});

console.log('=== WCAG 2.2 AA CONTRAST AUDIT RESULTS ===\n');
console.table(results);
