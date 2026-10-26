# Design Decision Proposal: Duolingo-Style Flat Design System for Little Muslim
**Document**: \`docs/design-language-proposal.md\`  
**Date**: October 26, 2026  
**Status**: DRAFT FOR APPROVAL (Audit Phase A — No code applied)

---

## 1. Design Language Vision & Principles

Little Muslim is evolving into a unified, accessible, child-friendly learning app inspired by Duolingo's clean, tactile, and playful design language:
1. **Flat Solid Surfaces**: Zero decorative gradients on UI cards, headers, or buttons. All structural surfaces use pure solid fills.
2. **Neutral Card Container Law**: All cards use pure white surface (\`AppColors.surface\`) paired with a single neutral border token (\`AppStroke.regular\`, 1.5px, \`AppColors.border\`). Zero tinted card backgrounds with matching colored borders.
3. **Tactile 3D Bottom Edge on Tappables Only**: Only interactive controls (buttons, selection tiles, lesson step circles) have a tactile bottom shadow edge. Non-tappable cards remain strictly flat.
4. **Semantic Color Accents**: Color is applied only to meaningful content—icons, status badges, progress bars, and active indicators—never to paint entire cards.
5. **Unified Corner Radii**: All elements draw from a single, predictable radius scale without arbitrary shapes or decorative bubbles.
6. **Universal Top Bar**: Every screen uses \`AppTopBar\` (\`shell\` variant on main navigation roots, \`page\` variant on inner pages).

---

## 2. Exact Design System Tokens

### 2.1 Surface & Fill Tokens
| Token | Hex Value | Semantic Purpose |
| :--- | :---: | :--- |
| \`AppColors.surface\` | \`0xFFFFFFFF\` | Primary card, sheet, and dialog background |
| \`AppColors.surfaceSubtle\` | \`0xFFF1F5F9\` | Input field background, disabled container, section card fill |
| \`AppColors.background\` | \`0xFFFFFFFF\` | Main screen canvas background |
| \`AppColors.backgroundSubtle\` | \`0xFFF8FAFC\` | Alternating row or secondary page canvas |

### 2.2 Border & Stroke Tokens
| Token | Width / Color | Usage Rule |
| :--- | :---: | :--- |
| \`AppStroke.hairline\` | 1.0 px | Dividers, subtle inner separators |
| \`AppStroke.regular\` | 1.5 px | **Universal card border**, input outlines, chip outlines |
| \`AppStroke.strong\` | 2.0 px | Selected / active interactive controls |
| \`AppStroke.thick\` | 3.0 px | Active lesson step node ring |
| \`AppColors.border\` | \`0xFFE2E8F0\` | **Single Universal Neutral Border** across all cards |
| \`AppColors.borderStrong\` | \`0xFFCBD5E1\` | High-contrast accessibility border |

### 2.3 Tactile 3D Bottom Edge Tokens
Tactile depth is reserved exclusively for tappables:
- **Buttons / Chips**: 3px - 4px vertical bevel offset.
- **Formula**:
  \`\`\`dart
  final bevelColor = HSLColor.fromColor(fillColor)
      .withLightness((HSLColor.fromColor(fillColor).lightness - 0.16).clamp(0.0, 1.0))
      .toColor();
  \`\`\`
- Non-interactive cards have \`depth: 0\` and use subtle ambient elevation (\`AppElevation.shadowCard\`).

---

## 3. Semantic Palette Specification

| State | Surface Fill (Subtle) | Neutral / Semantic Stroke | Text Token (High Contrast) | Icon / Accent Token | Contrast Ratio on Surface |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Brand (Learning)** | \`0xFFE8F8D8\` (brandLight) | \`0xFF86EFAC\` | \`0xFF2D6A00\` (textBrand) | \`0xFF58CC02\` | **5.94:1** (AA) |
| **Success (Completed)** | \`0xFFDCFCE7\` (successLight) | \`0xFF86EFAC\` | \`0xFF15803D\` (greenText) | \`0xFF16A34A\` | **4.57:1** (AA) |
| **Info (Guide/Audio)** | \`0xFFEFF6FF\` (infoLight) | \`0xFFBFDBFE\` | \`0xFF1D4ED8\` (blueText) | \`0xFF3B82F6\` | **5.84:1** (AA) |
| **Warning (Alert/Admin)**| \`0xFFFEF3C7\` (warningLight) | \`0xFFFDE68A\` | \`0xFF92400E\` (warningText) | \`0xFFF59E0B\` | **6.37:1** (AA) |
| **Error (Wrong/Retry)** | \`0xFFFEE2E2\` (errorLight) | \`0xFFFCA5A5\` | \`0xFFB91C1C\` (errorText) | \`0xFFEF4444\` | **5.89:1** (AA) |

---

## 4. Radius Scale Specification

| Token | Size | Allowed Components |
| :--- | :---: | :--- |
| \`AppRadius.xs\` | 4 px | Micro progress bars, tiny badges |
| \`AppRadius.sm\` | 8 px | Secondary tags, small button pills |
| \`AppRadius.md\` | 12 px | Input fields, category chips, list tile icon containers |
| \`AppRadius.lg\` | 16 px | **Standard Cards (\`AppCard\`)**, dialogs, bottom sheets |
| \`AppRadius.xl\` | 20 px | Featured hero banners |
| \`AppRadius.pill\` | 9999 px | Action buttons, floating counters, progress capsules |

*Banned*: Circular bubbles embedded in headers, arbitrary 24px/30px ad-hoc radii, and decorative blob containers.

---

## 5. Gradient Policy

### 5.1 Strict Allowlist
Gradients are allowed **only** in:
1. **Vector Mascots & Character Illustrations**: (\`quran_book_mascot.dart\`, \`vector_mascot.dart\`, \`faceless_silhouette.dart\`).
2. **Day / Night Celestial Scenes**: Sun/moon and sky transitions in prayer calculations.
3. **Celebratory Reward Particles**: Confetti and stars upon lesson completion.

### 5.2 Strict Ban
Gradients are **prohibited** on:
- Headers (all headers must use solid background \`AppColors.surface\` or solid \`AppColors.brandPrimary\`).
- Cards (all cards must use solid \`AppColors.surface\`).
- Buttons (must use solid flat fill with tactile 3D bevel).
- Screen backgrounds (must be solid \`AppColors.background\`).

---

## 6. Contrast-Safe Strategy for Brand Green (0xFF58CC02)

Our programmatic audit revealed that **White (\`#FFFFFF\`) on Brand Primary (\`0xFF58CC02\`) achieves only 2.09:1 contrast**, failing the WCAG 2.2 AA minimum threshold of 4.5:1 (and failing even the 3.0:1 large text threshold).

### Option A: Retain \`0xFF58CC02\` and Use Dark Text
- **Button Fill**: \`0xFF58CC02\` (Signature vibrant lime green).
- **Text & Icon**: \`AppColors.textPrimary\` (\`0xFF0F172A\`, Slate 900) or bold \`AppColors.textBrand\` (\`0xFF1B4D00\`).
- **Contrast Ratio**: **8.55:1** (Passes WCAG AAA for all text sizes).
- **Evaluation**: Preserves the fun, child-friendly identity while ensuring clear readability for children with visual impairments.

### Option B: Deepen Green for Text-Bearing Surfaces
- **Button Fill**: \`0xFF2E7D32\` (Accessible forest green).
- **Text & Icon**: \`AppColors.white\` (\`0xFFFFFFFF\`).
- **Contrast Ratio**: **5.13:1** (Passes WCAG AA Normal text threshold 4.5:1).
- **Evaluation**: Keeps white text on buttons, but dulls the youthful energy of the app.

### Recommendation: Hybrid Approach
- For primary action buttons: Implement **Option A** with heavy bold \`AppColors.textPrimary\` (8.55:1) on \`0xFF58CC02\`, or use Option B exclusively for accessibility high-contrast mode.
- For light green alert/badge fills (\`0xFFDCFCE7\`): Always use dark green text \`AppColors.greenText\` (\`0xFF15803D\`, 4.57:1).

---

## 7. Proposed New \`design:check\` Scanner Rules

To eliminate regressions permanently, \`tools/scan_design_audit.js\` and \`tools/design_check.js\` should incorporate:
1. **Rule: Ban Raw Buttons outside DS**:
   - Flag \`ElevatedButton\`, \`TextButton\`, \`OutlinedButton\`, \`FilledButton\`, \`DuolingoButton\`, \`DSButton\` outside \`lib/widgets/ds/\`.
2. **Rule: Ban Raw Inputs outside DS**:
   - Flag \`TextField\`, \`TextFormField\`, \`DropdownButton\`, \`Switch\`, \`Checkbox\` outside \`lib/widgets/ds/\`.
3. **Rule: Ban Raw Chips & SnackBars**:
   - Flag \`Chip\`, \`ActionChip\`, \`SnackBar\`, \`AlertDialog\` outside \`lib/widgets/ds/\`.
4. **Rule: Ban Gradients outside Allowlist**:
   - Flag any \`LinearGradient\`, \`RadialGradient\`, \`SweepGradient\` in screens, headers, or cards.
5. **Rule: Ban Tinted-Card Pattern**:
   - Flag any container combining a non-neutral fill with a colored stroke of the same hue.

### Baseline Management Plan
1. In Phase B, register these new rules with initial baseline counts matching the audited files.
2. As each screen is migrated in subsequent phases (Phase C: Qaida Chapters, Phase D: Quran & Prayer, Phase E: Inner screens), the baseline count for that file drops to 0.
3. The never-increase baseline prevents any developer or subagent from introducing new raw widgets or visual regressions.
