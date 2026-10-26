# Little Muslim — Comprehensive UI & Design Audit (Phase A)
**Audit Date**: October 26, 2026  
**Auditor**: Antigravity Agent  
**Scope**: Entire repository (`lib/**`, `test/**`, `assets/**`, `docs/**`)  
**Status**: AUDIT ONLY. No application code, scanners, baselines, or analysis options were modified during this phase.

---

## Executive Summary & Target Alignment

Little Muslim is currently in a visual transition between legacy Duolingo-like heavy gradients with tinted cards and a modern, high-contrast, child-friendly flat design system.
The target design language requires:
1. **Flat Solid Fills**: Zero gradients on UI surfaces, headers, cards, or buttons (gradients strictly reserved for mascots/illustrations).
2. **Neutral Card Surface**: Surface fill (`AppColors.surface`) + ONE neutral border token (`AppStroke.regular` with `AppColors.border`). Zero colored borders paired with tinted backgrounds.
3. **Tactile 3D Bottom Edge**: Reserved strictly for interactive tappables (buttons, option tiles). Non-tappable cards remain flat with neutral borders.
4. **Semantic Color Usage**: Color applied to icons, badges, progress indicators, and state tags, never to wash an entire card container.
5. **Unified Corner Radii**: Single predictable radius family (`AppRadius.md` = 12, `AppRadius.lg` = 16, `AppRadius.pill` = 9999). Elimination of arbitrary decorative circles and bubbles.
6. **Consistent Header Standard**: `AppTopBar.shell` on root screens and `AppTopBar.page` on child screens.

---

## A1. Visual Consistency Audit

### A1.1 Gradients Audit (Linear, Radial, Sweep)
> **Script Command**: `node tools/audit/audit_a1_visual.js`  
> **Total Occurrences**: 59 (51 Decorative, 8 Illustration)

#### Gradient Counts by File
| File | Total | Decorative (Violations) | Illustration (Exempt) |
| :--- | :---: | :---: | :---: |
| `lib/screens/basics/islam_basics_screen.dart` | 1 | 1 | 0 |
| `lib/screens/duas/duas_screen.dart` | 3 | 3 | 0 |
| `lib/screens/home/home_screen.dart` | 2 | 2 | 0 |
| `lib/screens/live_learning/live_learning_screen.dart` | 1 | 1 | 0 |
| `lib/screens/profile/profile_screen.dart` | 1 | 1 | 0 |
| `lib/screens/qaida/qaida_activity_screen.dart` | 8 | 8 | 0 |
| `lib/screens/qaida/qaida_lesson_screen.dart` | 1 | 1 | 0 |
| `lib/screens/qaida/qaida_next_course_screen.dart` | 1 | 1 | 0 |
| `lib/screens/qaida/qaida_report_screen.dart` | 1 | 1 | 0 |
| `lib/screens/qaida/qaida_revision_screen.dart` | 1 | 1 | 0 |
| `lib/screens/qaida/qaida_track_lessons_screen.dart` | 4 | 4 | 0 |
| `lib/screens/quran/quran_screen.dart` | 1 | 1 | 0 |
| `lib/screens/settings/settings_screen.dart` | 1 | 1 | 0 |
| `lib/theme/app_spacing.dart` | 5 | 5 | 0 |
| `lib/theme/design_system.dart` | 18 | 18 | 0 |
| `lib/widgets/duolingo_appbar.dart` | 2 | 2 | 0 |
| `lib/widgets/qaida/garden_progress_widget.dart` | 2 | 0 | 2 |
| `lib/widgets/quran_book_mascot.dart` | 5 | 0 | 5 |
| `lib/widgets/vector_icons.dart` | 1 | 0 | 1 |

#### Detailed Gradient Instances (file:line)
| Location | Type | Classification | Code Snippet |
| :--- | :---: | :---: | :--- |
| [`lib/screens/basics/islam_basics_screen.dart:1013`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L1013) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/duas/duas_screen.dart:620`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/duas/duas_screen.dart#L620) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/duas/duas_screen.dart:880`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/duas/duas_screen.dart#L880) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/duas/duas_screen.dart:1044`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/duas/duas_screen.dart#L1044) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/home/home_screen.dart:319`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L319) | `AppGradients.brand` | **Decorative** | `gradient: AppGradients.brand,` |
| [`lib/screens/home/home_screen.dart:1303`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L1303) | `AppGradients.brand` | **Decorative** | `gradient: AppGradients.brand,` |
| [`lib/screens/live_learning/live_learning_screen.dart:79`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/live_learning/live_learning_screen.dart#L79) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/profile/profile_screen.dart:61`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/profile/profile_screen.dart#L61) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:842`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L842) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:1433`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L1433) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2311`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2311) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3505`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3505) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:4688`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L4688) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5082`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5082) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5127`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5127) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5706`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5706) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/qaida/qaida_lesson_screen.dart:982`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_lesson_screen.dart#L982) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/qaida/qaida_next_course_screen.dart:411`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_next_course_screen.dart#L411) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/qaida/qaida_report_screen.dart:81`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_report_screen.dart#L81) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/qaida/qaida_revision_screen.dart:105`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_revision_screen.dart#L105) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:137`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L137) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:1013`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L1013) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:1114`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L1114) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:1559`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L1559) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/screens/quran/quran_screen.dart:531`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_screen.dart#L531) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/screens/settings/settings_screen.dart:450`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/settings/settings_screen.dart#L450) | `LinearGradient` | **Decorative** | `gradient: const LinearGradient(` |
| [`lib/theme/app_spacing.dart:226`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/app_spacing.dart#L226) | `AppGradients._` | **Decorative** | `AppGradients._();` |
| [`lib/theme/app_spacing.dart:228`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/app_spacing.dart#L228) | `LinearGradient` | **Decorative** | `static const LinearGradient brand = LinearGradient(` |
| [`lib/theme/app_spacing.dart:233`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/app_spacing.dart#L233) | `LinearGradient` | **Decorative** | `static const LinearGradient gold = LinearGradient(` |
| [`lib/theme/app_spacing.dart:239`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/app_spacing.dart#L239) | `LinearGradient` | **Decorative** | `static LinearGradient linear({` |
| [`lib/theme/app_spacing.dart:243`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/app_spacing.dart#L243) | `LinearGradient` | **Decorative** | `}) => LinearGradient(colors: colors, begin: begin, end: end);` |
| [`lib/theme/design_system.dart:839`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L839) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:902`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L902) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1318`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1318) | `LinearGradient` | **Decorative** | `..shader = LinearGradient(` |
| [`lib/theme/design_system.dart:1330`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1330) | `RadialGradient` | **Decorative** | `..shader = RadialGradient(` |
| [`lib/theme/design_system.dart:1396`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1396) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1410`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1410) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1441`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1441) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1478`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1478) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1496`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1496) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1516`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1516) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1648`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1648) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1656`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1656) | `RadialGradient` | **Decorative** | `..shader = const RadialGradient(` |
| [`lib/theme/design_system.dart:1684`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1684) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1712`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1712) | `RadialGradient` | **Decorative** | `..shader = const RadialGradient(` |
| [`lib/theme/design_system.dart:1738`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1738) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1820`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1820) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1836`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1836) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/theme/design_system.dart:1851`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart#L1851) | `LinearGradient` | **Decorative** | `..shader = const LinearGradient(` |
| [`lib/widgets/duolingo_appbar.dart:97`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_appbar.dart#L97) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/widgets/duolingo_appbar.dart:174`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_appbar.dart#L174) | `LinearGradient` | **Decorative** | `gradient: LinearGradient(` |
| [`lib/widgets/qaida/garden_progress_widget.dart:259`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/qaida/garden_progress_widget.dart#L259) | `LinearGradient` | **Illustration** | `..shader = const LinearGradient(` |
| [`lib/widgets/qaida/garden_progress_widget.dart:286`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/qaida/garden_progress_widget.dart#L286) | `LinearGradient` | **Illustration** | `..shader = const LinearGradient(` |
| [`lib/widgets/quran_book_mascot.dart:232`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/quran_book_mascot.dart#L232) | `LinearGradient` | **Illustration** | `..shader = const LinearGradient(` |
| [`lib/widgets/quran_book_mascot.dart:241`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/quran_book_mascot.dart#L241) | `LinearGradient` | **Illustration** | `..shader = LinearGradient(` |
| [`lib/widgets/quran_book_mascot.dart:317`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/quran_book_mascot.dart#L317) | `LinearGradient` | **Illustration** | `..shader = const LinearGradient(` |
| [`lib/widgets/quran_book_mascot.dart:336`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/quran_book_mascot.dart#L336) | `LinearGradient` | **Illustration** | `..shader = LinearGradient(` |
| [`lib/widgets/quran_book_mascot.dart:360`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/quran_book_mascot.dart#L360) | `LinearGradient` | **Illustration** | `..shader = LinearGradient(` |
| [`lib/widgets/vector_icons.dart:818`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/vector_icons.dart#L818) | `LinearGradient` | **Illustration** | `gradient: LinearGradient(` |

---

### A1.2 Tinted-Card Pattern Audit (Tinted Fill + Same-Hue Colored Border)
> **Script Command**: `node tools/audit/audit_a1_visual.js`  
> **Pattern Definition**: Card containers combining a tinted background fill (e.g. green 50, amber 100, blue 50, purple 50) with a colored stroke of the same hue.  
> **Total Violations Detected**: 37

| Location | Detected Hue | Fill Color Token/Value | Border Color Token/Value |
| :--- | :---: | :--- | :--- |
| [`lib/screens/achievements/achievements_screen.dart:158`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/achievements/achievements_screen.dart#L158) | **orange/amber** | `const Color(0xFFFEF3C7)` | `orange/amber border` |
| [`lib/screens/home/home_screen.dart:1443`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L1443) | **green/brand** | `isSelected ? AppColors.brandLight : AppColors.transparent` | `isSelected` |
| [`lib/screens/qaida/qaida_activity_screen.dart:780`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L780) | **orange/amber** | `const Color(0xFFFEF3C7)` | `Border.all(color: const Color(0xFFFDE68A)` |
| [`lib/screens/qaida/qaida_activity_screen.dart:1296`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L1296) | **orange/amber** | `isHovered` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:1296`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L1296) | **red/error** | `isHovered` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:1549`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L1549) | **green/brand** | `isHovered` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:1589`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L1589) | **green/brand** | `isHovered` | `green/brand border` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2352`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2352) | **orange/amber** | `const Color(0xFFFFFBEB)` | `Border.all(color: const Color(0xFFFDE68A))` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2493`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2493) | **green/brand** | `_shaddahPressCount >= 1` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2537`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2537) | **green/brand** | `_shaddahPressCount >= 2` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2757`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2757) | **red/error** | `_isRecordingVoice` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2817`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2817) | **purple** | `const Color(0xFFFAF5FF)` | `Border.all(color: const Color(0xFFE9D5FF))` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2945`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2945) | **green/brand** | `isRead` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3016`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3016) | **orange/amber** | `const Color(0xFFFEF3C7)` | `Border.all(color: const Color(0xFFFDE68A))` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3113`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3113) | **green/brand** | `isCorrect` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3113`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3113) | **red/error** | `isCorrect` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3285`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3285) | **green/brand** | `isCorrect` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3285`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3285) | **red/error** | `isCorrect` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3837`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3837) | **orange/amber** | `const Color(0xFFFFFBEB)` | `Border.all(color: const Color(0xFFFDE68A)` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3953`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3953) | **green/brand** | `isCaught ? const Color(0xFFDCFCE7) : Colors.white` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:4038`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L4038) | **green/brand** | `isHovered` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:4618`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L4618) | **green/brand** | `isSelected ? const Color(0xFFDCFCE7) : Colors.white` | `Border.all(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:4685`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L4685) | **orange/amber** | `orange/amber fill` | `orange/amber border` |
| [`lib/screens/qaida/qaida_activity_screen.dart:6032`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L6032) | **orange/amber** | `const Color(0xFFFEF3C7)` | `Border.all(color: const Color(0xFFFDE68A)` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:929`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L929) | **orange/amber** | `bossPassed` | `Border.all(` |
| [`lib/screens/qaida/qaida_exam_screen.dart:514`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L514) | **green/brand** | `isCorrect` | `Border.all(` |
| [`lib/screens/qaida/qaida_exam_screen.dart:514`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L514) | **red/error** | `isCorrect` | `Border.all(` |
| [`lib/screens/qaida/qaida_exam_screen.dart:675`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L675) | **orange/amber** | `passed` | `Border.all(` |
| [`lib/screens/qaida/qaida_exam_screen.dart:724`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L724) | **orange/amber** | `const Color(0xFFFEF3C7)` | `Border.all(color: const Color(0xFFFDE68A))` |
| [`lib/screens/qaida/qaida_report_screen.dart:339`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_report_screen.dart#L339) | **orange/amber** | `const Color(0xFFFEF3C7)` | `Border.all(color: const Color(0xFFFDE68A))` |
| [`lib/screens/qaida/qaida_report_screen.dart:1051`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_report_screen.dart#L1051) | **green/brand** | `_checkedToday ? const Color(0xFFDCFCE7) : AppTheme.duoGreen` | `Border.all(` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:1047`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L1047) | **orange/amber** | `isPassed ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7)` | `Border.all(` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:1148`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L1148) | **orange/amber** | `isPassed ? const Color(0xFFFEF3C7) : const Color(0xFFEEF2FF)` | `Border.all(` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:1148`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L1148) | **blue/indigo** | `isPassed ? const Color(0xFFFEF3C7) : const Color(0xFFEEF2FF)` | `Border.all(` |
| [`lib/screens/quran/quran_screen.dart:728`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_screen.dart#L728) | **green/brand** | `Color(0xFFE8F8D8)` | `green/brand border` |
| [`lib/widgets/ds/app_top_bar.dart:201`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/ds/app_top_bar.dart#L201) | **green/brand** | `AppColors.brandLight` | `Border.all(` |
| [`lib/widgets/vector_mascot.dart:72`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/vector_mascot.dart#L72) | **orange/amber** | `const Color(0xFFFFFBEB)` | `Border.all(color: const Color(0xFFFDE68A)` |

---

### A1.3 Borders, Strokes, and Radii Histogram vs Existing Tokens
> **Script Command**: `node tools/audit/audit_a1_visual.js`

#### Border Width Histogram
Existing Design Tokens: `AppStroke.none` (0), `AppStroke.hairline` (1.0), `AppStroke.regular` (1.5), `AppStroke.strong` (2.0), `AppStroke.thick` (3.0).

| Border Width / Token | Occurrences | Token Conformance |
| :--- | :---: | :--- |
| `AppStroke.regular` | 46 | ✅ Standard Token |
| `2` | 27 | ⚠️ Literal (Maps to AppStroke) |
| `1.5` | 24 | ⚠️ Literal (Maps to AppStroke) |
| `AppStroke.hairline` | 17 | ✅ Standard Token |
| `AppStroke.strong` | 4 | ✅ Standard Token |
| `4` | 3 | ❌ Non-standard literal |
| `borderWidth` | 3 | ❌ Non-standard literal |
| `AppStroke.none` | 2 | ✅ Standard Token |
| `width` | 2 | ❌ Non-standard literal |
| `3` | 1 | ⚠️ Literal (Maps to AppStroke) |
| `2.5` | 1 | ❌ Non-standard literal |
| `1.2` | 1 | ❌ Non-standard literal |
| `widget.isSelected` | 1 | ❌ Non-standard literal |
| `isSelected` | 1 | ❌ Non-standard literal |
| `1.4` | 1 | ❌ Non-standard literal |
| `AppStroke._` | 1 | ✅ Standard Token |
| `2.0` | 1 | ⚠️ Literal (Maps to AppStroke) |
| `3.5` | 1 | ❌ Non-standard literal |

#### Corner Radius Histogram
Existing Design Tokens: `AppRadius.xs` (4), `AppRadius.sm` (8), `AppRadius.md` (12), `AppRadius.lg` (16), `AppRadius.xl` (20), `AppRadius.xxl` (24), `AppRadius.pill` (9999).

| Radius / Token | Occurrences | Token Conformance |
| :--- | :---: | :--- |
| `Radius.circular(16)` | 71 | ❌ Raw Literal Radius |
| `Radius.circular(20)` | 60 | ❌ Raw Literal Radius |
| `Radius.circular(12)` | 50 | ❌ Raw Literal Radius |
| `Radius.circular(14)` | 36 | ❌ Raw Literal Radius |
| `Radius.circular(10)` | 30 | ❌ Raw Literal Radius |
| `Radius.circular(24)` | 28 | ❌ Raw Literal Radius |
| `Radius.circular(s` | 28 | ❌ Raw Literal Radius |
| `Radius.circular(8)` | 26 | ❌ Raw Literal Radius |
| `Radius.circular(18)` | 24 | ❌ Raw Literal Radius |
| `Radius.circular(22)` | 17 | ❌ Raw Literal Radius |
| `AppRadius.borderMd` | 15 | ✅ Standard Token |
| `AppRadius.borderSm` | 12 | ✅ Standard Token |
| `AppRadius.borderLg` | 10 | ✅ Standard Token |
| `AppRadius.radius` | 10 | ✅ Standard Token |
| `Radius.circular(15)` | 9 | ❌ Raw Literal Radius |
| `AppRadius.borderPill` | 9 | ✅ Standard Token |
| `Radius.circular(3)` | 7 | ❌ Raw Literal Radius |
| `Radius.circular(4)` | 6 | ❌ Raw Literal Radius |
| `Radius.circular(2)` | 6 | ❌ Raw Literal Radius |
| `Radius.circular(17)` | 5 | ❌ Raw Literal Radius |
| `AppRadius.borderXl` | 5 | ✅ Standard Token |
| `Radius.circular(DS.rLg)` | 5 | ❌ Raw Literal Radius |
| `Radius.circular(6)` | 5 | ❌ Raw Literal Radius |
| `Radius.circular(w` | 5 | ❌ Raw Literal Radius |
| `Radius.circular(28)` | 4 | ❌ Raw Literal Radius |

#### Border Color Histogram (Top 25)
| Border Color Token / Literal | Occurrences | Token Conformance |
| :--- | :---: | :--- |
| `const` | 74 | ❌ Hardcoded Literal Color |
| `AppColors.border` | 9 | ✅ App Token |
| `border` | 4 | ❌ Hardcoded Literal Color |
| `borderColor` | 3 | ❌ Hardcoded Literal Color |
| `DS.green500` | 3 | ❌ Hardcoded Literal Color |
| `Color(0xFFE2E8F0)` | 3 | ❌ Hardcoded Literal Color |
| `AppColors.amber500` | 2 | ✅ App Token |
| `AppColors.blue200` | 2 | ✅ App Token |
| `AppColors.purple200` | 2 | ✅ App Token |
| `AppColors.gray200` | 2 | ✅ App Token |
| `AppColors.slate200` | 2 | ✅ App Token |
| `AppColors.transparent` | 2 | ✅ App Token |
| `Color(0xFFE5E7EB)` | 2 | ❌ Hardcoded Literal Color |
| `AppTheme.primaryGreen` | 2 | ❌ Hardcoded Literal Color |
| `AppColors.brandPrimary` | 2 | ✅ App Token |
| `color` | 2 | ❌ Hardcoded Literal Color |
| `dua.accent.withValues(alpha: 0.25)` | 1 | ❌ Hardcoded Literal Color |
| `AppColors.green300` | 1 | ✅ App Token |
| `AppColors.orange200` | 1 | ✅ App Token |
| `DS.gold500` | 1 | ❌ Hardcoded Literal Color |
| `DS.border` | 1 | ❌ Hardcoded Literal Color |
| `Color(0xFFFFCC80)` | 1 | ❌ Hardcoded Literal Color |
| `color.withValues(alpha: 0.3)` | 1 | ❌ Hardcoded Literal Color |
| `AppTheme.primaryGreen.withValues(alpha: 0.35)` | 1 | ❌ Hardcoded Literal Color |
| `Colors.black.withValues(alpha: 0.05)` | 1 | ❌ Hardcoded Literal Color |

---

### A1.4 Decorative Shapes Audit (Bubbles, Positioned Circles, Blobs)
> **Script Command**: `node tools/audit/audit_a1_visual.js`  
> **Total Occurrences**: 96

| Location | Shape Type | Snippet |
| :--- | :---: | :--- |
| [`lib/core/navigation/module_registry.dart:36`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/core/navigation/module_registry.dart#L36) | CustomPaint / Vector Painter | `final CustomPainter iconPainter;` |
| [`lib/screens/basics/islam_basics_screen.dart:760`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L760) | Circular container | `shape: BoxShape.circle,` |
| [`lib/screens/basics/islam_basics_screen.dart:1030`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L1030) | Circular container | `shape: BoxShape.circle),` |
| [`lib/screens/home/home_screen.dart:940`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L940) | Circular container | `shape: BoxShape.circle,` |
| [`lib/screens/missions/daily_missions_screen.dart:183`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/missions/daily_missions_screen.dart#L183) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/onboarding/language_page.dart:157`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/language_page.dart#L157) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/onboarding/name_age_page.dart:73`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/name_age_page.dart#L73) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/onboarding/name_age_page.dart:345`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/name_age_page.dart#L345) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/onboarding/name_age_page.dart:432`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/name_age_page.dart#L432) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/onboarding/ready_page.dart:51`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/ready_page.dart#L51) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/onboarding/welcome_page.dart:76`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/welcome_page.dart#L76) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/profile/profile_screen.dart:90`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/profile/profile_screen.dart#L90) | Circular container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2129`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2129) | Circular container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2722`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2722) | Circular container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3143`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3143) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3686`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3686) | CustomPaint / Vector Painter | `child: CustomPaint(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:4641`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L4641) | Circular container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5355`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5355) | Circular container | `decoration: BoxDecoration(shape: BoxShape.circle, color: bg),` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5837`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5837) | CustomPaint / Vector Painter | `return CustomPaint(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5861`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5861) | CustomPaint / Vector Painter | `class _ConfettiPainter extends CustomPainter {` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5882`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5882) | CustomPaint / Vector Painter | `bool shouldRepaint(covariant CustomPainter oldDelegate) => true;` |
| [`lib/screens/qaida/qaida_activity_screen.dart:6151`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L6151) | CustomPaint / Vector Painter | `class _TraceCanvasPainter extends CustomPainter {` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:629`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L629) | Circular container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:1005`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L1005) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:1014`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L1014) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:1023`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L1023) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_exam_screen.dart:348`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L348) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_exam_screen.dart:544`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L544) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_exam_screen.dart:679`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L679) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_lesson_screen.dart:981`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_lesson_screen.dart#L981) | Circular container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:494`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L494) | CustomPaint / Vector Painter | `child: CustomPaint(` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:611`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L611) | CustomPaint / Vector Painter | `class _WindingRoadPainter extends CustomPainter {` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:771`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L771) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:1012`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L1012) | Empty circle container | `shape: BoxShape.circle,` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:1113`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L1113) | Empty circle container | `shape: BoxShape.circle,` |

---

### A1.5 Shadow & Elevation Histogram
> **Script Command**: `node tools/audit/audit_a1_visual.js`

| Shadow / Elevation | Occurrences | Conformance |
| :--- | :---: | :--- |
| `BoxShadow(custom)` | 139 | ❌ Raw BoxShadow |
| `BoxShadow(color: color, blurRadius: blurRadius, offset: offset)` | 1 | ❌ Raw BoxShadow |
| `BoxShadow(color: color, offset: Offset(0, depth)` | 1 | ❌ Raw BoxShadow |
| `AppElevation.shadowCard` | 1 | ✅ Token |
| `elevation: 0` | 2 | Raw Material Elevation |
| `elevation: 2` | 2 | Raw Material Elevation |

---

### A1.6 Screen Header Implementation Audit
> **Script Command**: `node tools/audit/audit_a1_visual.js`  
> **Goal**: 100% of screens migrated to `AppTopBar` (`shell` for root navigation, `page` for sub-screens).

| Screen | Current Header Implementation | Migration Target | Status |
| :--- | :--- | :--- | :---: |
| `lib/screens/achievements/achievements_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/basics/islam_basics_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/duas/duas_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/home/home_screen.dart` | `None / Custom` | `AppTopBar.shell` | ❌ Needs Migration |
| `lib/screens/live_learning/class_schedule.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/live_learning/live_learning_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/missions/daily_missions_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/onboarding/language_page.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/onboarding/name_age_page.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/onboarding/onboarding_screen.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/onboarding/ready_page.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/onboarding/welcome_page.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/prayer/prayer_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/prayer/prayer_times.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/profile/login_screen.dart` | `AppTopBar.page` | `AppTopBar.page` | ✅ Conforming |
| `lib/screens/profile/profile_screen.dart` | `AppTopBar.page` | `AppTopBar.page` | ✅ Conforming |
| `lib/screens/qaida/qaida_activity_screen.dart` | `Custom Gradient Header` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/qaida/qaida_chapters_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/qaida/qaida_exam_screen.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/qaida/qaida_lesson_screen.dart` | `Custom Gradient Header` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/qaida/qaida_letters.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/qaida/qaida_next_course_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/qaida/qaida_report_screen.dart` | `Custom Gradient Header` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/qaida/qaida_revision_screen.dart` | `Custom Gradient Header` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/qaida/qaida_track_lessons_screen.dart` | `Custom Gradient Header` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/quran/quran_data.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/quran/quran_reader_screen.dart` | `None / Custom` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/quran/quran_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/seerah/seerah_screen.dart` | `DuolingoPageHeader (Legacy)` | `AppTopBar.page` | ❌ Needs Migration |
| `lib/screens/settings/settings_screen.dart` | `AppTopBar.page` | `AppTopBar.page` | ✅ Conforming |

---

### A1.7 Card Background Tints Histogram
> **Script Command**: `node tools/audit/audit_a1_visual.js`  
> Used across cards and containers, to propose a streamlined semantic palette:

| Tint Color Token | Count | Proposed Semantic Purpose |
| :--- | :---: | :--- |
| `AppColors.slate100` | 2 | Neutral card fill / Subtle background |
| `AppColors.brandLight` | 2 | Brand highlight / Active step |
| `AppColors.surfaceSubtle` | 2 | Semantic tag |
| `AppColors.slate50` | 1 | Neutral card fill / Subtle background |

---

## A2. Component Usage Audit (Raw vs DS)
> **Script Command**: `node tools/audit/audit_a2_components.js`

### Summary Table: Raw Usage vs Design System Components
| Component Category | Raw Usages (Outside `lib/widgets/ds`) | DS Usages | Missing DS Equivalent Components |
| :--- | :---: | :---: | :--- |
| **Buttons** (`ElevatedButton`, `TextButton`, `OutlinedButton`, `IconButton`, `DuolingoButton`) | 83 | 24 | None (Migrate all to `AppButton`) |
| **Inputs** (`TextField`, `DropdownButton`, `Switch`, `Checkbox`, `Slider`) | 27 | 0 | **`AppTextField`**, **`AppSwitchTile`**, **`AppSelect`** |
| **Badges / Chips / Pills** (`Chip`, `Badge`, `_CategoryPill`, Containers) | 26 | 13 | **`AppChip`**, **`AppBadge`** already exist, need adoption |
| **Dialogs & Bottom Sheets & Alerts** (`showDialog`, `AlertDialog`, `SnackBar`) | 22 | 16 | **`AppToast`**, **`AppBanner`** |
| **List Tiles & Rows** (`ListTile`) | 9 | 10 | **`AppListTile`**, **`AppIconTile`** |
| **Progress Indicators** (`LinearProgressIndicator`, `CircularProgressIndicator`) | 19 | 3 | **`AppProgressBar`** (linear), need **`AppProgressCircle`** |

### Proposed New DS Components Specification
1. **`AppTextField`**:
   - *Variants*: `standard`, `search`, `multiline`
   - *Tokens*: Fill: `AppColors.surfaceSubtle`, Border: `AppBorders.regular` (focus: `AppColors.brandPrimary`, error: `AppColors.error`), Radius: `AppRadius.borderLg` (16px), Text: `AppTextStyles.body`, Height: min 48px accessible touch target.
2. **`AppSwitchTile`**:
   - *Tokens*: Label: `AppTextStyles.titleSmall`, Subtitle: `AppTextStyles.caption`, Active color: `AppColors.brandPrimary`, Track: `AppColors.slate200`.
3. **`AppBanner`**:
   - *Variants*: `info`, `warning`, `success`, `admin`
   - *Tokens*: Fill: `AppColors.infoLight` / `AppColors.warningLight` / `AppColors.successLight`, Border: `AppStroke.regular`, Radius: `AppRadius.borderLg`, Icon: semantic colored icon. Fully responsive multi-line layout to avoid clipping.
4. **`AppSectionHeader`**:
   - *Tokens*: Title: `AppTextStyles.title`, Action: `AppButton.ghost`, Padding: `AppSpacing.insetHorizontalLg`.
5. **`AppIconTile`**:
   - *Tokens*: Leading icon in neutral container, Title: `AppTextStyles.titleSmall`, Border: `AppBorders.regular`, Surface: `AppColors.surface`.
6. **`AppEmptyState`**:
   - *Tokens*: Illustration: SVG/vector mascot, Title: `AppTextStyles.title`, Description: `AppTextStyles.body`, Primary Action: `AppButton`.
7. **`AppToast`**:
   - *Tokens*: Surface: `AppColors.textPrimary`, Text: `AppColors.white`, Elevation: `AppElevation.shadowLg`, Radius: `AppRadius.borderPill`.

---

## A3. WCAG 2.2 AA Accessibility Audit

### A3.1 Contrast Audit
> **Script Command**: `node tools/audit/audit_a3_contrast.js`  
> **Thresholds**: Normal Text $\ge$ 4.5:1, Large Text ($\ge$24px or $\ge$18.66px Bold) $\ge$ 3.0:1, UI Components/Borders $\ge$ 3.0:1.

| Color Pair | Contrast Ratio | WCAG 2.2 Status | Where Used in App | Issue & Fix Recommendation |
| :--- | :---: | :---: | :--- | :--- |
| **White on Brand Primary (0xFF58CC02)** | **2.09:1** | ❌ **FAIL** (Threshold 4.5:1 / 3.0:1) | Primary `AppButton`, `DuolingoButton`, Badges | **Critical Failure**. Use `textPrimary` (#0F172A) on brand green (8.55:1), or darken brand green to #2E7D32 for white text. |
| **`textPrimary` on Brand Primary** | **8.55:1** | ✅ **PASS (AAA)** | Proposed Accessible Button Pattern | Highly recommended for all child buttons. |
| **White on Brand Dark (0xFF46A302)** | **3.23:1** | ⚠️ **PASS Large only** (Fail Normal) | 3D bevels, Header titles | Use dark text or large bold text only. |
| **Darker Green (0xFF2E7D32) on White** | **5.13:1** | ✅ **PASS (AA Normal)** | Proposed Option B Brand Green | Meets full WCAG AA normal text requirements with white. |
| **White on Orange (0xFFFF9600)** | **2.18:1** | ❌ **FAIL** (< 3.0) | Streak badge, mission buttons | Use dark text `textPrimary` or `orangeDark` background. |
| **White on Accent Gold (0xFFFFC800)** | **1.55:1** | ❌ **FAIL** (< 3.0) | XP / Star coins pill | Replace text color with `AppColors.textPrimary` (11.49:1 ratio). |
| **`textPrimary` on Accent Gold** | **11.49:1** | ✅ **PASS (AAA)** | Star / Coin / Level badges | Perfect contrast. |
| **White on Blue (0xFF1CB0F6)** | **2.44:1** | ❌ **FAIL** (< 3.0) | Info pills, audio buttons | Replace white text with `AppColors.textPrimary`. |
| **`textTertiary` (0xFF94A3B8) on White** | **2.56:1** | ❌ **FAIL** (< 4.5) | Captions, subtitle footers | Upgrade subtle captions to `AppColors.textSecondary` (7.58:1). |
| **`textDisabled` (0xFFCBD5E1) on White** | **1.48:1** | ❌ **FAIL** (< 4.5) | Locked lessons, disabled actions | Provide secondary icon indicator (lock icon) so text color is not sole signifier. |
| **`greenText` on `greenLight` (Success)** | **4.57:1** | ✅ **PASS (AA Normal)** | Success alerts, completed steps | Compliant. |
| **`textBrand` on `brandLight`** | **5.94:1** | ✅ **PASS (AA Normal)** | Active salah card, prayer times | Compliant. |
| **`orangeText` on `orangeLight`** | **4.52:1** | ✅ **PASS (AA Normal)** | Dua categories | Compliant. |
| **`blueText` on `blueLight`** | **5.84:1** | ✅ **PASS (AA Normal)** | Quran audio cards | Compliant. |
| **`purpleText` on `purpleLight`** | **5.92:1** | ✅ **PASS (AA Normal)** | Seerah stories | Compliant. |
| **`warningText` on `warningLight`** | **6.37:1** | ✅ **PASS (AA Normal)** | Admin banner | Compliant. |
| **Border (Slate 200) on White Surface** | **1.23:1** | ⚠️ Low border contrast | Card boundaries | For accessibility, card surface separation is reinforced by elevation shadow or Slate 300 (`borderStrong`). |

---

### A3.2 Touch Target Audit
> **Script Command**: `node tools/audit/audit_a3_semantics_targets.js`  
> - **WCAG 2.5.8 Minimum AA Threshold**: 24x24 px  
> - **Apple / Android Child-Accessible Recommendation**: 44x44 px (or 48x48 px)

- **Tappables smaller than 24x24 (Strict WCAG 2.5.8 AA Failures)**: 0
- **Tappables smaller than 44x44 (Child Usability Failures)**: 4 detected
  1. `lib/widgets/duolingo_appbar.dart:143`: Header back button Container `width: 38, height: 38` (inside InkWell).
  2. `lib/screens/qaida/qaida_chapters_screen.dart:581`: Header progress badge `height: 28`.
  3. `lib/screens/home/home_screen.dart:148`: Student mode button in Admin Banner `height: ~24`.
  4. `lib/widgets/faceless_silhouette.dart:296`: Avatar selector item `size: 38`.

---

### A3.3 Semantics & Accessibility Audit
> **Script Command**: `node tools/audit/audit_a3_semantics_targets.js`

- **Unlabeled Icon Buttons**: 9 occurrences (missing `tooltip` and `Semantics(label: ...)`).
  - `lib/screens/prayer/prayer_screen.dart:1153, 1157`
  - `lib/screens/profile/login_screen.dart:75` (password visibility toggle)
  - `lib/screens/qaida/qaida_activity_screen.dart:927`
  - `lib/screens/quran/quran_screen.dart:163, 432`
  - `lib/widgets/ds/app_top_bar.dart:84`
  - `lib/widgets/language_switcher.dart:147, 161`
- **Images Missing Semantics**: 14 occurrences (neither `semanticLabel` nor `excludeFromSemantics: true`).
- **TextFields Missing Accessible Labels**: 1 occurrence (`lib/screens/onboarding/name_age_page.dart:199`).
- **Animations Lacking Reduced Motion**: 6 animation controllers run continuously without checking `MediaQuery.of(context).disableAnimations`.

---

### A3.4 Text Scaling & Layout Overflow Reproduction Test
> **Test Command**: `flutter test test/text_scaling_audit_test.dart`

#### Verified Reproduction: Italian Admin Banner Cramping & Overflow
In Italian (`it`), `home.admin_mode_notice` translates to **"Modalità amministratore: tutti i livelli sbloccati"** and the button text is **"Modalità studente"**.
On a 360px screen at `textScale: 1.5`:
```
--- Italian Admin Banner Metrics at scale 1.5 ---
Admin Notice Text Size: Size(0.0, 990.0)
Student Mode Button Size: Size(284.8, 20.0)
Total Row constraint width: 360 - 32 = 328px
Remaining width for notice: 328 - 284.75 = 43.25px
══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════════════════════════════════════
A RenderFlex overflowed by 35 pixels on the right.
The relevant error-causing widget was:
  Row:file:///Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart:133:28
```
**Root Cause**: A rigid horizontal `Row` with `Expanded` text and an inflexible button child. At 1.5x scale, the button expands to 285px wide, starving the label and blowing past the screen bounds.  
**Fix**: Convert banner to a flex column on narrow screens or wrap in an accessible `AppBanner` component with `Wrap` or vertical button layout.

---

## A4. Heuristic Evaluation (Nielsen's 10 + Child-App Concerns)

### Evaluated Screens
1. **Home Screen** (`HomeScreen`)
2. **Qaida Chapters Screen** (`QaidaChaptersScreen`)
3. **Qaida Lesson Screen** (`QaidaLessonScreen`)
4. **Quran Reader / Screen** (`QuranScreen`, `QuranReaderScreen`)
5. **Settings Screen** (`SettingsScreen`)
6. **Profile / Login Screen** (`ProfileScreen`, `LoginScreen`)

#### Screenshots Rendered at 360px Width (Real Fonts)
Evidence screenshots captured under `docs/screenshots/audit/`:
- Home: `docs/screenshots/audit/home_360_en.png`, `home_360_hi.png`, `home_360_it.png`
- Qaida Chapters: `docs/screenshots/audit/qaida_chapters_360_en.png`, `qaida_chapters_360_hi.png`, `qaida_chapters_360_it.png`
- Qaida Lesson: `docs/screenshots/audit/qaida_lesson_360_en.png`, `qaida_lesson_360_hi.png`, `qaida_lesson_360_it.png`
- Quran Screen: `docs/screenshots/audit/quran_360_en.png`, `quran_360_hi.png`, `quran_360_it.png`
- Quran Reader: `docs/screenshots/audit/quran_reader_360_en.png`, `quran_reader_360_hi.png`, `quran_reader_360_it.png`
- Settings: `docs/screenshots/audit/settings_360_en.png`, `settings_360_hi.png`, `settings_360_it.png`
- Profile: `docs/screenshots/audit/profile_360_en.png`, `profile_360_hi.png`, `profile_360_it.png`

*Verification Note regarding Fonts*: `assets/fonts/` only contains `Amiri-Regular.ttf` and `Amiri-Bold.ttf`. Noto Sans Bengali, Noto Sans Devanagari, and Inter are loaded dynamically at runtime via `google_fonts`. During automated offline tests, system fallbacks (Roboto / Arial Unicode) are utilized to ensure distinct glyph rendering without modifying repo assets.

### Heuristic Findings Matrix
| # | Nielsen Heuristic / Child Concern | Screen | Severity (0-4) | Evidence (file:line / screenshot) | Finding & Recommendation |
| :-: | :--- | :--- | :-: | :--- | :--- |
| **1** | **Child Concern: Parental Gate** | Home / Settings | **4 (Critical)** | `home_screen.dart:144` | **Zero Parental Gate on Admin Mode**: Any 6-year-old child can tap the Admin Mode button or access settings and toggle unlocked levels. *Recommendation*: Add a math multiplication challenge or parental PIN dialog before unlocking admin mode or resetting progress. |
| **2** | **Child Concern: Cognitive Load** | Home | **3 (Major)** | `home_screen.dart:125-450` | **Too Many Competing Visual Elements**: Home displays an Admin banner, Noor mascot speech card, streak banner, live class banner, and 4 colored cards simultaneously. *Recommendation*: Collapse secondary banners into dismissible pills; use clean white cards with single neutral borders. |
| **3** | **Consistency & Standards** | Qaida Chapters | **3 (Major)** | `qaida_chapters_screen.dart:555` | **Mismatched Header**: Uses legacy `DuolingoPageHeader` with green gradient and bubble accents instead of `AppTopBar.page`. *Recommendation*: Replace with `AppTopBar.page`. |
| **4** | **Consistency & Standards** | Qaida Chapters | **3 (Major)** | `qaida_chapters_screen.dart:158,239,320,395` | **Tinted-Card Anti-Pattern**: 4 cards have 4 distinct border colors (indigo, green, amber, purple). *Recommendation*: Standardize to white surface with `AppStroke.regular` neutral border; keep color only on step icons. |
| **5** | **Error Prevention & Recovery** | Qaida Lesson | **2 (Medium)** | `qaida_lesson_screen.dart:340` | **Harsh Fail Feedback on Mistake**: Wrong letter selection triggers red buzzer without giving child an immediate second hint. *Recommendation*: Provide gentle encouraging audio ("Try again!") and keep attempts friendly. |
| **6** | **Child Concern: Tap Target Size** | All screens | **3 (Major)** | `duolingo_appbar.dart:143` | **Sub-44px Back Button**: The back button on legacy headers is 38x38px, causing miss-taps for young children. *Recommendation*: Enforce minimum 48x48px hit box across all buttons. |
| **7** | **Aesthetic & Minimalist Design** | Qaida Chapters | **2 (Medium)** | `garden_progress_widget.dart:259` | **Multi-Gradient Garden Scene**: Uses 3 nested linear gradients conflicting with the flat Duolingo aesthetic. *Recommendation*: Flatten background hills to solid fills with clean SVG vectors. |
| **8** | **Visibility of System Status** | Quran Reader | **2 (Medium)** | `quran_reader_screen.dart:34` | **Ambiguous Audio Buffering**: When switching ayahs, no tactile indicator shows that audio is streaming until sound plays. *Recommendation*: Add visual loading spinner in the audio playback bar. |
| **9** | **User Control & Freedom** | Quran Screen | **2 (Medium)** | `quran_screen.dart:880` | **No Quick Return to Last Read**: When browsing 114 surahs, the child has to scroll all the way down without a "Resume Surah" floating action button. *Recommendation*: Add top "Continue Reading" banner. |
| **10** | **Recognition vs Recall** | Settings | **1 (Minor)** | `settings_screen.dart:39-120` | **Dense List of Toggles**: Settings uses standard Material ListTile toggles that feel like an adult OS setting rather than a playful child interface. *Recommendation*: Use card-based `AppSwitchTile` with friendly Islamic icons. |

---

## A5. Prioritized Action Plan & Effort Estimation

| Priority | Category | Task | Affected Files | Effort (Hours) |
| :---: | :---: | :--- | :--- | :---: |
| **P0** | **A11y & Bug** | Fix Italian Admin Banner text overflow at $\ge$1.5x scale | `lib/screens/home/home_screen.dart` | 1.5h |
| **P0** | **A11y** | Resolve Brand Green contrast failure (White on 0xFF58CC02 is 2.09:1) | `lib/theme/app_colors.dart`, `lib/widgets/ds/app_button.dart` | 2.0h |
| **P0** | **Safety** | Implement Parental Gate modal for Admin & Settings | New DS Component `AppParentalGate` | 2.5h |
| **P1** | **Consistency** | Migrate `QaidaChaptersScreen` to `AppTopBar.page` & neutral card borders | `lib/screens/qaida/qaida_chapters_screen.dart` | 3.0h |
| **P1** | **Consistency** | Retire legacy `DuolingoHeader` / `DuolingoPageHeader` / `_HeaderBubble` | `lib/widgets/duolingo_appbar.dart` | 2.0h |
| **P1** | **Design Gate** | Introduce missing DS components: `AppTextField`, `AppSwitchTile`, `AppBanner` | `lib/widgets/ds/` | 4.0h |
| **P1** | **Consistency** | Migrate remaining screens (`Prayer`, `Duas`, `Seerah`, `Basics`, `Missions`) to `AppTopBar.page` | `lib/screens/**` | 5.0h |
| **P2** | **Polish** | Enforce $\ge$44x44 touch targets on all interactive icon buttons | Entire codebase | 2.0h |
| **P2** | **A11y** | Add `MediaQuery.disableAnimations` checks to 6 animation controllers | 6 files identified in audit | 1.5h |
| **P2** | **A11y** | Add missing semantics labels & tooltips to 9 icon buttons and 14 images | Various screens | 2.0h |
