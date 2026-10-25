# Design Audit Report (Validated)

This report catalogs all design system violations across `lib/` (**excluding `lib/theme/` and `lib/widgets/ds/`** where tokens and shared components live).
Each offending line is assigned to exactly one primary category, ensuring **zero double-counting** across categories.

---

## 1. Summary by Category

| Category | Offending Lines Count | Detection Rule & Description |
|---|:---:|---|
| **Hardcoded Colors** | **1881** | Raw `Color(0x...)`, `Colors.xxx` (excluding `Colors.transparent` and `AppColors`), hex strings, and inline opacity modifiers |
| **Hardcoded Text Styles** | **1331** | Inline `TextStyle`, `fontSize`, `FontWeight`, `letterSpacing`, and direct font calls |
| **Hardcoded Spacing** | **1132** | Literal `EdgeInsets`, `SizedBox(height/width)` spacers, and `Padding` values |
| **Hardcoded Radii** | **465** | Explicit `BorderRadius.circular(n)` and `Radius.circular(n)` numbers |
| **Borders, Shadows & Gradients** | **369** | Inline `Border.all`, `BorderSide`, `BoxShadow`, and `LinearGradient` decorations |
| **Hardcoded Sizes** | **25** | Fixed icon sizes, avatar radii, and app bar height literals |
| **Duplicated UI Widgets** | **78** | Scattered headers (`DuolingoAppBar`, `DuolingoPageHeader`, custom `AppBar`), cards, buttons, and inline avatars |
| **Fixed Overflow Risks** | **57** | Hardcoded container/button/chip widths with Text vulnerable to overflow in longer languages (`bn`, `hi`, `it`) |
| **TOTAL UNIQUE OFFENDING LINES** | **5338** | **Total design system violations (Zero double-counted lines)** |

---

## 2. Top 10 Offending Files

| Rank | File Path | Total Lines | Category Breakdown (Directly Computed) |
|:---:|---|:---:|---|
| 1 | [`lib/screens/qaida/qaida_activity_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart) | **1244** | Hardcoded Colors: 476, Hardcoded Text Styles: 274, Hardcoded Spacing: 239, Hardcoded Radii: 110, Hardcoded Borders, Shadows & Gradients: 121, Hardcoded Sizes: 3, Duplicated Headers, Cards & Avatars: 10, Fixed Dimensions (Overflow Risks): 11 |
| 2 | [`lib/screens/home/home_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart) | **368** | Hardcoded Colors: 98, Hardcoded Text Styles: 102, Hardcoded Spacing: 89, Hardcoded Radii: 41, Hardcoded Borders, Shadows & Gradients: 29, Hardcoded Sizes: 1, Duplicated Headers, Cards & Avatars: 3, Fixed Dimensions (Overflow Risks): 5 |
| 3 | [`lib/screens/qaida/qaida_track_lessons_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart) | **289** | Hardcoded Colors: 130, Hardcoded Text Styles: 63, Hardcoded Spacing: 50, Hardcoded Radii: 23, Hardcoded Borders, Shadows & Gradients: 22, Duplicated Headers, Cards & Avatars: 1 |
| 4 | [`lib/screens/qaida/qaida_chapters_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart) | **271** | Hardcoded Colors: 93, Hardcoded Text Styles: 69, Hardcoded Spacing: 54, Hardcoded Radii: 27, Hardcoded Borders, Shadows & Gradients: 18, Hardcoded Sizes: 1, Duplicated Headers, Cards & Avatars: 2, Fixed Dimensions (Overflow Risks): 7 |
| 5 | [`lib/screens/prayer/prayer_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/prayer/prayer_screen.dart) | **258** | Hardcoded Colors: 73, Hardcoded Text Styles: 80, Hardcoded Spacing: 64, Hardcoded Radii: 24, Hardcoded Borders, Shadows & Gradients: 7, Hardcoded Sizes: 4, Duplicated Headers, Cards & Avatars: 3, Fixed Dimensions (Overflow Risks): 3 |
| 6 | [`lib/screens/qaida/qaida_report_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_report_screen.dart) | **251** | Hardcoded Colors: 88, Hardcoded Text Styles: 64, Hardcoded Spacing: 54, Hardcoded Radii: 23, Hardcoded Borders, Shadows & Gradients: 16, Hardcoded Sizes: 2, Duplicated Headers, Cards & Avatars: 3, Fixed Dimensions (Overflow Risks): 1 |
| 7 | [`lib/screens/duas/duas_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/duas/duas_screen.dart) | **212** | Hardcoded Colors: 86, Hardcoded Text Styles: 56, Hardcoded Spacing: 40, Hardcoded Radii: 19, Hardcoded Borders, Shadows & Gradients: 8, Hardcoded Sizes: 1, Duplicated Headers, Cards & Avatars: 2 |
| 8 | [`lib/screens/basics/islam_basics_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart) | **189** | Hardcoded Colors: 45, Hardcoded Text Styles: 65, Hardcoded Spacing: 52, Hardcoded Radii: 12, Hardcoded Borders, Shadows & Gradients: 5, Hardcoded Sizes: 2, Duplicated Headers, Cards & Avatars: 6, Fixed Dimensions (Overflow Risks): 2 |
| 9 | [`lib/screens/seerah/seerah_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/seerah/seerah_screen.dart) | **177** | Hardcoded Colors: 82, Hardcoded Text Styles: 39, Hardcoded Spacing: 34, Hardcoded Radii: 12, Hardcoded Borders, Shadows & Gradients: 8, Duplicated Headers, Cards & Avatars: 2 |
| 10 | [`lib/screens/quran/quran_screen.dart`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_screen.dart) | **172** | Hardcoded Colors: 53, Hardcoded Text Styles: 36, Hardcoded Spacing: 47, Hardcoded Radii: 19, Hardcoded Borders, Shadows & Gradients: 11, Hardcoded Sizes: 1, Duplicated Headers, Cards & Avatars: 1, Fixed Dimensions (Overflow Risks): 4 |

---

## 3. All Duplicated Widgets (78 occurrences)

| File & Line | Component | Code Snippet |
|---|---|---|
| [`lib/screens/achievements/achievements_screen.dart:103`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/achievements/achievements_screen.dart#L103) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/achievements/achievements_screen.dart:237`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/achievements/achievements_screen.dart#L237) | DuolingoCard widget | `DuolingoCard(` |
| [`lib/screens/basics/islam_basics_screen.dart:466`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L466) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/basics/islam_basics_screen.dart:874`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L874) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/screens/basics/islam_basics_screen.dart:931`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L931) | Duolingo button widget | `child: Duolingo3DButton(` |
| [`lib/screens/basics/islam_basics_screen.dart:955`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L955) | DuolingoCard widget | `Widget build(BuildContext context) =&gt; DuolingoCard(` |
| [`lib/screens/basics/islam_basics_screen.dart:962`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L962) | Inline avatar widget | `CircleAvatar(` |
| [`lib/screens/basics/islam_basics_screen.dart:1067`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L1067) | Inline avatar widget | `CircleAvatar(` |
| [`lib/screens/duas/duas_screen.dart:401`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/duas/duas_screen.dart#L401) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/duas/duas_screen.dart:418`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/duas/duas_screen.dart#L418) | DuolingoCard widget | `DuolingoCard(` |
| [`lib/screens/home/home_screen.dart:401`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L401) | DuolingoCard widget | `DuolingoCard(` |
| [`lib/screens/home/home_screen.dart:668`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L668) | DuolingoCard widget | `DuolingoCard(` |
| [`lib/screens/home/home_screen.dart:736`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L736) | DuolingoCard widget | `DuolingoCard(` |
| [`lib/screens/live_learning/live_learning_screen.dart:65`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/live_learning/live_learning_screen.dart#L65) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/live_learning/live_learning_screen.dart:267`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/live_learning/live_learning_screen.dart#L267) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/live_learning/live_learning_screen.dart:275`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/live_learning/live_learning_screen.dart#L275) | DuolingoCard widget | `DuolingoCard(` |
| [`lib/screens/live_learning/live_learning_screen.dart:398`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/live_learning/live_learning_screen.dart#L398) | DuolingoCard widget | `return DuolingoCard(` |
| [`lib/screens/live_learning/live_learning_screen.dart:495`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/live_learning/live_learning_screen.dart#L495) | DuolingoCard widget | `Widget build(BuildContext context) =&gt; DuolingoCard(` |
| [`lib/screens/missions/daily_missions_screen.dart:35`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/missions/daily_missions_screen.dart#L35) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/missions/daily_missions_screen.dart:138`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/missions/daily_missions_screen.dart#L138) | DuolingoCard widget | `DuolingoCard(` |
| [`lib/screens/missions/daily_missions_screen.dart:192`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/missions/daily_missions_screen.dart#L192) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/screens/prayer/prayer_screen.dart:307`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/prayer/prayer_screen.dart#L307) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/prayer/prayer_screen.dart:1101`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/prayer/prayer_screen.dart#L1101) | DuolingoCard widget | `Widget build(BuildContext context) =&gt; DuolingoCard(` |
| [`lib/screens/prayer/prayer_screen.dart:1482`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/prayer/prayer_screen.dart#L1482) | Inline avatar widget | `leading: CircleAvatar(` |
| [`lib/screens/profile/login_screen.dart:87`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/profile/login_screen.dart#L87) | Duolingo button widget | `child: Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:692`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L692) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:1731`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L1731) | Duolingo button widget | `child: Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:1910`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L1910) | Duolingo button widget | `child: Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2838`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2838) | Duolingo button widget | `child: Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2852`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2852) | Duolingo button widget | `child: Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:4798`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L4798) | Duolingo button widget | `child: Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:4911`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L4911) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5021`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5021) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5036`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5036) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_activity_screen.dart:6139`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L6139) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:567`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L567) | DuolingoPageHeader | `Widget build(BuildContext context) =&gt; DuolingoPageHeader(` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:1181`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L1181) | Inline avatar widget | `CircleAvatar(` |
| [`lib/screens/qaida/qaida_exam_screen.dart:596`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L596) | Duolingo button widget | `child: Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_exam_screen.dart:758`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L758) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_exam_screen.dart:764`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L764) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_exam_screen.dart:777`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L777) | Duolingo button widget | `Duolingo3DButton.secondary(` |
| [`lib/screens/qaida/qaida_next_course_screen.dart:370`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_next_course_screen.dart#L370) | DuolingoPageHeader | `child: DuolingoPageHeader(` |
| [`lib/screens/qaida/qaida_next_course_screen.dart:421`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_next_course_screen.dart#L421) | Inline avatar widget | `CircleAvatar(` |
| [`lib/screens/qaida/qaida_next_course_screen.dart:480`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_next_course_screen.dart#L480) | Duolingo button widget | `Duolingo3DButton.secondary(` |
| [`lib/screens/qaida/qaida_next_course_screen.dart:519`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_next_course_screen.dart#L519) | Duolingo button widget | `child: Duolingo3DButton(` |
| [`lib/screens/qaida/qaida_report_screen.dart:100`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_report_screen.dart#L100) | Inline avatar widget | `CircleAvatar(` |
| [`lib/screens/qaida/qaida_report_screen.dart:424`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_report_screen.dart#L424) | Inline avatar widget | `CircleAvatar(` |
| [`lib/screens/qaida/qaida_report_screen.dart:502`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_report_screen.dart#L502) | Inline avatar widget | `CircleAvatar(` |
| [`lib/screens/qaida/qaida_track_lessons_screen.dart:1592`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart#L1592) | Inline avatar widget | `CircleAvatar(` |
| [`lib/screens/quran/quran_reader_screen.dart:495`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_reader_screen.dart#L495) | DuolingoCard widget | `Widget build(BuildContext context) =&gt; DuolingoCard(` |
| [`lib/screens/quran/quran_reader_screen.dart:566`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_reader_screen.dart#L566) | DuolingoCard widget | `Widget build(BuildContext context) =&gt; DuolingoCard(` |
| [`lib/screens/quran/quran_screen.dart:96`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_screen.dart#L96) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/seerah/seerah_screen.dart:209`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/seerah/seerah_screen.dart#L209) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/seerah/seerah_screen.dart:587`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/seerah/seerah_screen.dart#L587) | DuolingoPageHeader | `DuolingoPageHeader(` |
| [`lib/screens/settings/settings_screen.dart:462`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/settings/settings_screen.dart#L462) | Inline avatar widget | `const CircleAvatar(` |
| [`lib/screens/settings/settings_screen.dart:766`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/settings/settings_screen.dart#L766) | Inline avatar widget | `CircleAvatar(` |
| [`lib/widgets/app_states.dart:81`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/app_states.dart#L81) | DuolingoCard widget | `child: DuolingoCard(` |
| [`lib/widgets/app_states.dart:150`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/app_states.dart#L150) | DuolingoCard widget | `child: DuolingoCard(` |
| [`lib/widgets/duolingo_appbar.dart:250`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_appbar.dart#L250) | DuolingoPageHeader | `typedef DuolingoPageHeader = DuolingoHeader;` |
| [`lib/widgets/duolingo_appbar.dart:417`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_appbar.dart#L417) | DuolingoCard widget | `class DuolingoCard extends StatefulWidget {` |
| [`lib/widgets/duolingo_appbar.dart:418`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_appbar.dart#L418) | DuolingoCard widget | `const DuolingoCard({` |
| [`lib/widgets/duolingo_appbar.dart:438`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_appbar.dart#L438) | DuolingoCard widget | `State&lt;DuolingoCard&gt; createState() =&gt; _DuolingoCardState();` |
| [`lib/widgets/duolingo_appbar.dart:441`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_appbar.dart#L441) | DuolingoCard widget | `class _DuolingoCardState extends State&lt;DuolingoCard&gt; {` |
| [`lib/widgets/duolingo_button.dart:6`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L6) | Duolingo button widget | `class Duolingo3DButton extends StatefulWidget {` |
| [`lib/widgets/duolingo_button.dart:7`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L7) | Duolingo button widget | `const Duolingo3DButton({` |
| [`lib/widgets/duolingo_button.dart:39`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L39) | Duolingo button widget | `factory Duolingo3DButton.secondary({` |
| [`lib/widgets/duolingo_button.dart:48`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L48) | Duolingo button widget | `return Duolingo3DButton(` |
| [`lib/widgets/duolingo_button.dart:63`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L63) | Duolingo button widget | `factory Duolingo3DButton.gold({` |
| [`lib/widgets/duolingo_button.dart:72`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L72) | Duolingo button widget | `return Duolingo3DButton(` |
| [`lib/widgets/duolingo_button.dart:87`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L87) | Duolingo button widget | `factory Duolingo3DButton.brandGreen({` |
| [`lib/widgets/duolingo_button.dart:96`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L96) | Duolingo button widget | `return Duolingo3DButton(` |
| [`lib/widgets/duolingo_button.dart:111`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L111) | Duolingo button widget | `factory Duolingo3DButton.teal({` |
| [`lib/widgets/duolingo_button.dart:119`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L119) | Duolingo button widget | `}) =&gt; Duolingo3DButton.brandGreen(` |
| [`lib/widgets/duolingo_button.dart:130`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L130) | Duolingo button widget | `State&lt;Duolingo3DButton&gt; createState() =&gt; _Duolingo3DButtonState();` |
| [`lib/widgets/duolingo_button.dart:133`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart#L133) | Duolingo button widget | `class _Duolingo3DButtonState extends State&lt;Duolingo3DButton&gt; {` |
| [`lib/widgets/duolingo_path_view.dart:323`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_path_view.dart#L323) | Duolingo button widget | `Duolingo3DButton(` |
| [`lib/widgets/duolingo_path_view.dart:388`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_path_view.dart#L388) | Duolingo button widget | `Duolingo3DButton.gold(` |
| [`lib/widgets/duolingo_path_view.dart:396`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_path_view.dart#L396) | Duolingo button widget | `Duolingo3DButton(` |

---

## 4. All Fixed Dimensions / Overflow Risks (57 occurrences)

| File & Line | Component | Code Snippet |
|---|---|---|
| [`lib/screens/basics/islam_basics_screen.dart:471`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L471) | Fixed dimension on DuolingoPageHeader containing text (overflow risk) | `width: 36,` |
| [`lib/screens/basics/islam_basics_screen.dart:472`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart#L472) | Fixed dimension on DuolingoPageHeader containing text (overflow risk) | `height: 36,` |
| [`lib/screens/home/home_screen.dart:194`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L194) | Fixed dimension on SizedBox containing text (overflow risk) | `height: 38,` |
| [`lib/screens/home/home_screen.dart:718`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L718) | Fixed dimension on DSButton containing text (overflow risk) | `height: 38,` |
| [`lib/screens/home/home_screen.dart:719`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L719) | Fixed dimension on DSButton containing text (overflow risk) | `width: 84,` |
| [`lib/screens/home/home_screen.dart:1185`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L1185) | Fixed dimension on Container containing text (overflow risk) | `width: 54,` |
| [`lib/screens/home/home_screen.dart:1186`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart#L1186) | Fixed dimension on Container containing text (overflow risk) | `height: 54,` |
| [`lib/screens/prayer/prayer_screen.dart:1324`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/prayer/prayer_screen.dart#L1324) | Fixed dimension on Container containing text (overflow risk) | `width: 112,` |
| [`lib/screens/prayer/prayer_screen.dart:1419`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/prayer/prayer_screen.dart#L1419) | Fixed dimension on Container containing text (overflow risk) | `width: 23,` |
| [`lib/screens/prayer/prayer_screen.dart:1420`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/prayer/prayer_screen.dart#L1420) | Fixed dimension on Container containing text (overflow risk) | `height: 23,` |
| [`lib/screens/profile/profile_screen.dart:247`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/profile/profile_screen.dart#L247) | Fixed dimension on SizedBox containing text (overflow risk) | `height: 48,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:1794`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L1794) | Fixed dimension on AnimatedContainer containing text (overflow risk) | `height: 72,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2308`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2308) | Fixed dimension on AnimatedContainer containing text (overflow risk) | `height: 20,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2309`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2309) | Fixed dimension on AnimatedContainer containing text (overflow risk) | `width: 60.0 + (_maddStretchCount * 55.0),` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2947`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2947) | Fixed dimension on AnimatedContainer containing text (overflow risk) | `width: 90,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:2948`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L2948) | Fixed dimension on AnimatedContainer containing text (overflow risk) | `height: 90,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3140`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3140) | Fixed dimension on Container containing text (overflow risk) | `width: 28,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3141`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3141) | Fixed dimension on Container containing text (overflow risk) | `height: 28,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3612`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3612) | Fixed dimension on Container containing text (overflow risk) | `height: 250,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:3747`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L3747) | Fixed dimension on DSButton containing text (overflow risk) | `height: 44,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5353`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5353) | Fixed dimension on Container containing text (overflow risk) | `width: 32,` |
| [`lib/screens/qaida/qaida_activity_screen.dart:5354`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart#L5354) | Fixed dimension on Container containing text (overflow risk) | `height: 32,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:502`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L502) | Fixed dimension on DSButton containing text (overflow risk) | `height: 38,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:572`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L572) | Fixed dimension on DuolingoPageHeader containing text (overflow risk) | `width: 36,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:573`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L573) | Fixed dimension on DuolingoPageHeader containing text (overflow risk) | `height: 36,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:625`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L625) | Fixed dimension on Container containing text (overflow risk) | `width: 24,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:626`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L626) | Fixed dimension on Container containing text (overflow risk) | `height: 24,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:751`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L751) | Fixed dimension on Container containing text (overflow risk) | `width: 52,` |
| [`lib/screens/qaida/qaida_chapters_screen.dart:752`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart#L752) | Fixed dimension on Container containing text (overflow risk) | `height: 52,` |
| [`lib/screens/qaida/qaida_exam_screen.dart:541`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L541) | Fixed dimension on Container containing text (overflow risk) | `width: 28,` |
| [`lib/screens/qaida/qaida_exam_screen.dart:542`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L542) | Fixed dimension on Container containing text (overflow risk) | `height: 28,` |
| [`lib/screens/qaida/qaida_exam_screen.dart:676`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L676) | Fixed dimension on Container containing text (overflow risk) | `width: 120,` |
| [`lib/screens/qaida/qaida_exam_screen.dart:677`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart#L677) | Fixed dimension on Container containing text (overflow risk) | `height: 120,` |
| [`lib/screens/qaida/qaida_lesson_screen.dart:415`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_lesson_screen.dart#L415) | Fixed dimension on Container containing text (overflow risk) | `width: 92,` |
| [`lib/screens/qaida/qaida_lesson_screen.dart:416`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_lesson_screen.dart#L416) | Fixed dimension on Container containing text (overflow risk) | `height: 76,` |
| [`lib/screens/qaida/qaida_lesson_screen.dart:584`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_lesson_screen.dart#L584) | Fixed dimension on SizedBox containing text (overflow risk) | `height: 50,` |
| [`lib/screens/qaida/qaida_lesson_screen.dart:924`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_lesson_screen.dart#L924) | Fixed dimension on SizedBox containing text (overflow risk) | `height: 37,` |
| [`lib/screens/qaida/qaida_lesson_screen.dart:978`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_lesson_screen.dart#L978) | Fixed dimension on Container containing text (overflow risk) | `width: 68,` |
| [`lib/screens/qaida/qaida_lesson_screen.dart:979`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_lesson_screen.dart#L979) | Fixed dimension on Container containing text (overflow risk) | `height: 68,` |
| [`lib/screens/qaida/qaida_report_screen.dart:749`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_report_screen.dart#L749) | Fixed dimension on DSButton containing text (overflow risk) | `height: 42,` |
| [`lib/screens/qaida/qaida_revision_screen.dart:527`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_revision_screen.dart#L527) | Fixed dimension on Container containing text (overflow risk) | `width: 48,` |
| [`lib/screens/qaida/qaida_revision_screen.dart:528`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_revision_screen.dart#L528) | Fixed dimension on Container containing text (overflow risk) | `height: 48,` |
| [`lib/screens/quran/quran_reader_screen.dart:593`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_reader_screen.dart#L593) | Fixed dimension on Container containing text (overflow risk) | `width: 28,` |
| [`lib/screens/quran/quran_reader_screen.dart:594`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_reader_screen.dart#L594) | Fixed dimension on Container containing text (overflow risk) | `height: 28,` |
| [`lib/screens/quran/quran_screen.dart:693`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_screen.dart#L693) | Fixed dimension on Container containing text (overflow risk) | `width: 40,` |
| [`lib/screens/quran/quran_screen.dart:694`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_screen.dart#L694) | Fixed dimension on Container containing text (overflow risk) | `height: 40,` |
| [`lib/screens/quran/quran_screen.dart:892`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_screen.dart#L892) | Fixed dimension on Container containing text (overflow risk) | `width: 44,` |
| [`lib/screens/quran/quran_screen.dart:893`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_screen.dart#L893) | Fixed dimension on Container containing text (overflow risk) | `height: 44,` |
| [`lib/screens/settings/settings_screen.dart:558`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/settings/settings_screen.dart#L558) | Fixed dimension on Column containing text (overflow risk) | `const Divider(height: 16),` |
| [`lib/screens/settings/settings_screen.dart:566`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/settings/settings_screen.dart#L566) | Fixed dimension on SizedBox containing text (overflow risk) | `height: 50,` |
| [`lib/screens/settings/settings_screen.dart:599`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/settings/settings_screen.dart#L599) | Fixed dimension on Column containing text (overflow risk) | `const Divider(height: 12),` |
| [`lib/widgets/duolingo_appbar.dart:383`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_appbar.dart#L383) | Fixed dimension on AnimatedContainer containing text (overflow risk) | `height: 40,` |
| [`lib/widgets/duolingo_path_view.dart:328`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_path_view.dart#L328) | Fixed dimension on Duolingo3DButton containing text (overflow risk) | `height: 46,` |
| [`lib/widgets/duolingo_path_view.dart:399`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_path_view.dart#L399) | Fixed dimension on Duolingo3DButton containing text (overflow risk) | `height: 48,` |
| [`lib/widgets/language_switcher.dart:192`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/language_switcher.dart#L192) | Fixed dimension on Expanded containing text (overflow risk) | `separatorBuilder: (_, __) =&gt; const Divider(height: 1),` |
| [`lib/widgets/language_switcher.dart:201`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/language_switcher.dart#L201) | Fixed dimension on Container containing text (overflow risk) | `width: 40,` |
| [`lib/widgets/language_switcher.dart:202`](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/language_switcher.dart#L202) | Fixed dimension on Container containing text (overflow risk) | `height: 40,` |
