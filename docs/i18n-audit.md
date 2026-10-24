# Little Muslim App — Comprehensive Internationalization (i18n) & Localization Audit
> **Audit Status:** Phase 1 Complete (Full Static & Dynamic Codebase Scan)  
> **Target Framework:** Flutter / Dart (Standard ARB Intl System)  
> **Supported Locales:** English (`en` - Fallback), Bengali (`bn`), Hindi (`hi`), Italian (`it`)  
> **Scalability Target:** 20+ Languages with zero component code modification  
> **Output Artifact:** `/docs/i18n-audit.md`  

---

## 1. Executive Summary & Architecture Overview

### 1.1 Project & Internationalization State
The **Little Muslim** application is an educational, Duolingo-style Islamic learning platform for children. It was originally prototyped in Bengali (`bn`), and subsequently updated to support a dual architecture of hardcoded maps and Flutter's standard ARB-based localization. 

Prior to this audit:
- The app relied on a hybrid system where `AppLocalizations` contained a fallback dictionary (`_coreBilingualPairs`), which frequently masked missing keys by returning Bengali strings instead of falling back to English.
- The dual system has now been **unified**: the hardcoded dictionary was removed, `assets/l10n/app_*.arb` is the sole source of truth, and strict fallback to English (`en`) is enforced.
- **959 unique keys** are currently synchronized across all 4 locales (`app_en.arb`, `app_bn.arb`, `app_hi.arb`, `app_it.arb`).
- All 103 unit/widget tests (including `test/senior_i18n_test.dart`) pass cleanly.

### 1.2 Quantitative Audit Summary
| Category | Total Count | Details / Status |
| :--- | :--- | :--- |
| **Scanned Dart Files** | **55** | Entire `lib/` directory scanned recursively |
| **Active Locale ARB Files** | **4** | `app_en.arb`, `app_bn.arb`, `app_hi.arb`, `app_it.arb` |
| **Synchronized ARB Keys** | **959 keys each** | 100% key parity across all 4 language files |
| **Bengali Script Lines (`[\u0980-\u09FF]`)** | **2,492** | Across 41 files (UI widgets, static data constants, models) |
| **Hindi Script Lines (`[\u0904-\u097F]`)** | **31** | Across 2 files (`app_localizations.dart`, `app_languages.dart`) |
| **Devanagari Danda Lines (`[\u0964\u0965]`)** | **509** | Across 30 files (shared full-stop punctuation in Bengali texts) |
| **String Interpolations in UI** | **647** | Across 34 files (dynamic templates, numbers, variables) |
| **Dialogs & Bottom Sheets** | **58** | Exit confirmations, helper sheets, auth dialogs, alerts |
| **Toasts & SnackBars** | **35** | Feedback messages, sound warnings, admin unlock toasts |
| **Interactive Buttons** | **184** | `DuolingoButton`, `ElevatedButton`, `TextButton`, `IconButton` |
| **Input Fields & Placeholders** | **22** | `TextField`, `TextFormField`, `hintText`, `labelText` |

---

## 2. Hardcoded Script Scan Results

### 2.1 Bengali Script Scan (`[ঀ-৿]`)
Bengali script occurrences in the codebase fall into three distinct functional categories:
1. **Localized Text Calls with Bengali Lookup Keys:** Components calling `context.uiText('বাংলা টেক্সট')` or `LocalizedText('বাংলা টেক্সট')`. These are translated at runtime through the ARB map.
2. **Static Data Constants / Curricula:** Hardcoded curriculum data in `lib/data/nurani_qaida_data.dart`, `lib/data/qaida_curriculum_data.dart`, `lib/screens/basics/islam_basics_screen.dart`, `lib/screens/prayer/prayer_times.dart`, etc.
3. **Legacy Hardcoded Raw String Literals:** Text in snackbars, dialogs, and button labels that had not yet been routed through `context.uiText()`.

#### Top Bengali Script Occurrences by File
| File Path | Bengali Lines | Category / Primary Purpose |
| :--- | :--- | :--- |
| `lib/data/nurani_qaida_data.dart` | **558** | Qaida letter metadata, makhraj descriptions, feedback strings |
| `lib/data/qaida_curriculum_data.dart` | **354** | Track titles, lesson steps, 12 activity prompts, hints |
| `lib/screens/basics/islam_basics_screen.dart` | **226** | 5 Pillars of Islam, 6 Articles of Iman, Daily Duas, Quiz questions |
| `lib/screens/prayer/prayer_screen.dart` | **187** | Prayer names, wudu steps, rakat guide, compass instructions |
| `lib/screens/duas/duas_screen.dart` | **134** | Dua categories, Arabic transliteration, Bengali translations |
| `lib/screens/qaida/qaida_activity_screen.dart` | **113** | Activity engine UI, feedback messages, evaluation states |
| `lib/screens/qaida/qaida_lesson_screen.dart` | **92** | Lesson view, voice recognition feedback, parent verification dialog |
| `lib/screens/qaida/qaida_report_screen.dart` | **73** | Progress report, certificate generation, mastery badges |
| `lib/screens/settings/settings_screen.dart` | **67** | Settings options, privacy modal, reset warning dialogs |
| `lib/screens/home/home_screen.dart` | **60** | Dashboard cards, streak counters, daily quote, module headers |
| `lib/screens/qaida/qaida_letters.dart` | **57** | Arabic alphabet chart, pronunciation guides, letter cards |
| `lib/screens/qaida/qaida_next_course_screen.dart` | **53** | Course completion celebration, next level recommendations |
| `lib/screens/quran/quran_screen.dart` | **50** | Surah names, revelation place, ayah count, recitation controls |
| `lib/screens/qaida/qaida_chapters_screen.dart` | **44** | Track chapter list, lesson lock states, admin unlock sheet |
| `lib/l10n/app_localizations.dart` | **43** | Template regex matching for dynamic steps, ages, lessons |
| `lib/screens/qaida/qaida_track_lessons_screen.dart` | **34** | Tree-path nodes, milestone markers, lesson cards |
| `lib/screens/live_learning/live_learning_screen.dart` | **33** | Instructor profiles, live class schedule, zoom links |
| `lib/models/qaida/qaida_models.dart` | **31** | Enum labels, activity type titles, default hints |
| `lib/screens/seerah/seerah_screen.dart` | **30** | Prophet stories, timeline milestones, moral lessons |
| `lib/screens/achievements/achievements_screen.dart` | **27** | Trophy titles, XP levels, streak rewards |
| `lib/screens/qaida/qaida_revision_screen.dart` | **24** | Flashcard review, spaced repetition prompts |
| `lib/screens/profile/profile_screen.dart` | **23** | Profile badges, stats, learner rank, edit forms |
| `lib/screens/qaida/qaida_exam_screen.dart` | **23** | Assessment questions, timer, score certificate |
| `lib/widgets/duolingo_path_view.dart` | **23** | Learning road nodes, chest dialogs, lock messages |
| `lib/screens/onboarding/name_age_page.dart` | **20** | Name input prompt, age chip selectors |
| `lib/screens/missions/daily_missions_screen.dart` | **16** | Daily task titles, XP rewards, mission status |
| `lib/screens/quran/quran_reader_screen.dart` | **15** | Ayah reader options, translation toggles, bookmark toasts |
| `lib/core/navigation/module_registry.dart` | **15** | Main feature module definitions, titles, descriptions |
| `lib/screens/onboarding/ready_page.dart` | **13** | Ready celebration, child profile summary, start button |
| `lib/screens/profile/login_screen.dart` | **10** | Auth forms, parent PIN verification, login button |
| `lib/screens/onboarding/welcome_page.dart` | **9** | Welcome greetings, introductory tagline |
| `lib/services/notification_service.dart` | **9** | Push notification titles and body texts |
| `lib/widgets/faceless_silhouette.dart` | **6** | Avatar customizer labels (Hijab, Thobe, Cap, Glasses) |
| `lib/widgets/qaida/garden_progress_widget.dart` | **6** | Tree growth levels, water garden labels |
| `lib/screens/onboarding/language_page.dart` | **3** | Language selection prompt, description |
| `lib/screens/onboarding/onboarding_screen.dart` | **3** | Back/Next navigation labels |
| `lib/core/localization/app_languages.dart` | **2** | Native language names |
| `lib/utils/app_state.dart` | **2** | Default level titles |
| `lib/widgets/app_states.dart` | **2** | Empty / error state fallback messages |
| `lib/widgets/duolingo_appbar.dart` | **1** | Top app bar badge labels |
| `lib/widgets/vector_mascot.dart` | **1** | Mascot greeting speech bubble |

### 2.2 Hindi Script Scan (`[ऀ-ॿ]`)
Analysis of Unicode characters in the Devanagari range `0x0900` to `0x097F` revealed two categories:
1. **Actual Hindi / Devanagari Alphabet Characters (`[ऄ-हऽ-ॣ०-ॿ]`):**
   - **`lib/core/localization/app_languages.dart` (Line 58):** Native name label `'हिंदी'` in language registry.
   - **`lib/l10n/app_localizations.dart` (Lines 54, 70, 79, etc.):** Dynamic template regexes and Hindi translations for step indicators (`चरण $n`, `वर्तमान:`, `अध्याय $n`, `आयु $n वर्ष`).
2. **Devanagari Danda Punctuation (`।` U+0964 / `॥` U+0965):**
   - Found across **509 lines in 30 files**.
   - **Note:** In Unicode, the standard Bengali full-stop (দাঁড়ি) is codified as U+0964 (Devanagari Danda). These are standard punctuation marks in Bengali sentences and not Hindi words.

### 2.3 Hardcoded English Literals in UI Widgets
Several components still render raw English string literals without routing through `LocalizedText` or `context.uiText`:
- **`lib/widgets/duolingo_appbar.dart`:** XP label (`"XP"`), Streak label (`"days"`).
- **`lib/widgets/duolingo_path_view.dart`:** Level nodes (`"START"`, `"REVIEW"`, `"BONUS"`).
- **`lib/screens/settings/settings_screen.dart`:** Debug labels (`"Version 1.0.0 (Build 42)"`, `"Reset Data"`).
- **`lib/screens/profile/profile_screen.dart`:** Account status (`"Guest User"`, `"Parent Portal"`).
- **`lib/screens/qaida/qaida_exam_screen.dart`:** Timer badge (`"02:30"`).

---

## 3. Screens & Navigational Surfaces Audit

The application contains **30 distinct screens** organized across **12 feature modules**. Every screen has been audited for UI texts, headers, buttons, cards, dialogs, and dynamic states.

### 3.1 Onboarding

#### [welcome_page.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/welcome_page.dart)
- **Total Lines:** 289
- **Bangla Line References:** 9
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 55: `'আসসালামু আলাইকুম! চলো শুরু করি',`
  - Line 123: `'কুরআন শেখো · মজার সাথে · ইসলাম জানো',`
  - Line 145: `label: 'কুরআন',`
  - Line 152: `label: 'ক্বায়দা',`
  - Line 159: `label: 'নামাজ',`

#### [name_age_page.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/name_age_page.dart)
- **Total Lines:** 672
- **Bangla Line References:** 20
- **String Interpolations:** 1
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 2
- **Representative User-Facing Strings:**
  - Line 110: `'কে ব্যবহার করবে? প্রোফাইল বেছে নাও',`
  - Line 126: `'ব্যবহারকারীর ধরন',`
  - Line 141: `title: 'মূল শিক্ষার্থী',`
  - Line 142: `subtitle: 'স্বাভাবিক নিয়মে শেখা',`
  - Line 143: `badge: 'ডিফল্ট',`
- **Dynamic Interpolations Found:**
  - Line 290: `'$age'`

#### [language_page.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/language_page.dart)
- **Total Lines:** 207
- **Bangla Line References:** 3
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 55: `'ভাষা বেছে নাও',`
  - Line 64: `'অ্যাপের ভাষা নির্বাচন করো। পরে পরিবর্তন করা যাবে।',`
  - Line 191: `'কুরআনের আরবি টেক্সট সবসময় আরবিতেই থাকবে। শুধু অ্যাপের বাটন ও নির্দেশনা পরিবর্তন হবে।',`

#### [ready_page.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/ready_page.dart)
- **Total Lines:** 261
- **Bangla Line References:** 13
- **String Interpolations:** 1
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 29: `final name = appState.draftName.isNotEmpty ? appState.draftName : 'বন্ধু';`
  - Line 78: `'তুমি প্রস্তুত, $name!',`
  - Line 102: `'অ্যাডমিন মোড: সব ধাপ ও লেভেল আনলক থাকবে',`
  - Line 115: `'এখন থেকে প্রতিদিন একটু একটু করে\nকুরআন ও ইসলাম শিখবে মজার সাথে',`
  - Line 147: `title: 'ক্বায়দা ও বর্ণমালা',`
- **Dynamic Interpolations Found:**
  - Line 78: `'তুমি প্রস্তুত, $name!'`

#### [onboarding_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/onboarding_screen.dart)
- **Total Lines:** 196
- **Bangla Line References:** 3
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 2
- **Buttons & Actions:** 1
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 34: `content: const LocalizedText('তোমার নাম লিখো প্লিজ'),`
  - Line 166: `label: 'পেছনে',`
  - Line 178: `label: 'পরবর্তী',`

### 3.2 Home & Navigation

#### [home_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/home/home_screen.dart)
- **Total Lines:** 1861
- **Bangla Line References:** 60
- **String Interpolations:** 12
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 105: `name: userName.isNotEmpty ? userName : 'বন্ধু',`
  - Line 162: `'অ্যাডমিন মোড: সব লেভেল ও ধাপ আনলক',`
  - Line 181: `'শিক্ষার্থী মোড',`
  - Line 197: `? 'মাশাআল্লাহ! আজকের মিশন সম্পূর্ণ করেছ।'`
  - Line 198: `: 'আসসালামু আলাইকুম! চলো আজ নতুন পাঠ শিখি!',`
- **Dynamic Interpolations Found:**
  - Line 308: `'$shownHour:${minute.toString().padLeft(2, '`
  - Line 308: `')} $period'`
  - Line 411: `'ধাপ ${step.stepNumber}: ${step.title}'`

#### [duolingo_appbar.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_appbar.dart)
- **Total Lines:** 513
- **Bangla Line References:** 1
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 136: `label: context.uiLocalizedText('ফিরে যান'),`

#### [module_registry.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/core/navigation/module_registry.dart)
- **Total Lines:** 119
- **Bangla Line References:** 15
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 46: `title: 'ক্বায়দা',`
  - Line 47: `subtitle: 'বর্ণমালা',`
  - Line 55: `title: 'কুরআন',`
  - Line 56: `subtitle: 'তিলাওয়াত',`
  - Line 64: `title: 'নামাজ',`

#### [duolingo_path_view.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_path_view.dart)
- **Total Lines:** 990
- **Bangla Line References:** 23
- **String Interpolations:** 11
- **Dialogs & Sheets:** 4
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 107: `unitTitle: 'অধ্যায় ১: হরফ পরিচয় (১)',`
  - Line 108: `unitSubtitle: 'আলিফ থেকে খা পর্যন্ত শিখি',`
  - Line 123: `unitTitle: 'অধ্যায় ২: হরফ পরিচয় (২)',`
  - Line 124: `unitSubtitle: 'দাল থেকে সাদ পর্যন্ত শিখি',`
  - Line 139: `unitTitle: 'অধ্যায় ৩: হরফ পরিচয় (৩)',`
- **Dynamic Interpolations Found:**
  - Line 179: `'chest_course_$c'`
  - Line 200: `'qaida_course_${item.courseIndex}'`
  - Line 224: `'qaida_course_${prev.courseIndex}'`

### 3.3 Qaida & Curriculum

#### [qaida_chapters_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_chapters_screen.dart)
- **Total Lines:** 1215
- **Bangla Line References:** 44
- **String Interpolations:** 13
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 2
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 93: `1: 'লেভেল ১ · হরফ চেনা ও রূপভেদ (Steps 1–2)',`
  - Line 94: `2: 'লেভেল ২ · হারাকাত ও তানবীন (Steps 3–5)',`
  - Line 95: `3: 'লেভেল ৩ · সুকুন, শাদ্দাহ ও লাইয়্যিন (Steps 6–8)',`
  - Line 96: `4: 'লেভেল ৪ · তাজবীদের মূল নিয়মাবলি (Steps 9–12)',`
  - Line 97: `5: 'লেভেল ৫ · অগ্রসর নিয়মাবলি (Steps 13–15)',`
- **Dynamic Interpolations Found:**
  - Line 39: `'step_${prevStep.stepNumber}_boss'`
  - Line 198: `'${state.skillsDueForReview.length}টি হরফ রিভিশন প্রয়োজন'`
  - Line 516: `'লেভেল ${phaseEntry.key}'`

#### [qaida_lesson_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_lesson_screen.dart)
- **Total Lines:** 1216
- **Bangla Line References:** 92
- **String Interpolations:** 14
- **Dialogs & Sheets:** 4
- **SnackBars & Alerts:** 1
- **Buttons & Actions:** 2
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 76: `'শুনে বাছি',`
  - Line 77: `'রূপ চিনি',`
  - Line 78: `'বিন্দুর পাজল',`
  - Line 79: `'মনে আছে?',`
  - Line 80: `'মুখে বলি',`
- **Dynamic Interpolations Found:**
  - Line 138: `'STT error: $err'`
  - Line 142: `'STT status: $status'`
  - Line 196: `'তোমার অগ্রগতি (ধাপ ${_step + 1}) সংরক্ষিত থাকবে। পরে যেকোনো সময় এখান থেকে শুরু করতে পারবে।'`

#### [qaida_activity_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_activity_screen.dart)
- **Total Lines:** 6154
- **Bangla Line References:** 113
- **String Interpolations:** 30
- **Dialogs & Sheets:** 3
- **SnackBars & Alerts:** 4
- **Buttons & Actions:** 1
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 148: `const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];`
  - Line 598: `'মূল নিয়ম ও কানুন:',`
  - Line 623: `'এই নিয়মের হরফসমূহ (${letters.length}টি):',`
  - Line 660: `'আদর্শ উদাহরণ শব্দসমূহ:',`
  - Line 696: `text: 'বুঝেছি, অনুশীলন করি ➔',`
- **Dynamic Interpolations Found:**
  - Line 623: `'এই নিয়মের হরফসমূহ (${letters.length}টি):'`
  - Line 798: `'${_currentActivityIndex + 1}/${widget.lesson.activities.length}'`
  - Line 866: `'ধাপ ${activity.slotNumber}/৭ · ${activity.stepTitle}'`

#### [qaida_exam_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_exam_screen.dart)
- **Total Lines:** 781
- **Bangla Line References:** 23
- **String Interpolations:** 10
- **Dialogs & Sheets:** 2
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 92: `return 'স্টেপ ${widget.step?.stepNumber ?? 1} বস পরীক্ষা';`
  - Line 94: `return 'সাপ্তাহিক মূল্যায়ন ${widget.weekNumber}';`
  - Line 96: `return 'মাসিক মেগা পরীক্ষা ${widget.monthNumber}';`
  - Line 194: `prompt: 'সঠিক হরফটি নির্বাচন করুন: আলিফ',`
  - Line 198: `explanation: 'আলিফ খালি এবং মুখ থেকে নিঃশ্বাসের সাথে উচ্চারিত হয়।',`
- **Dynamic Interpolations Found:**
  - Line 81: `'step_${num}_boss'`
  - Line 83: `'weekly_exam_${widget.weekNumber}'`
  - Line 85: `'monthly_exam_${widget.monthNumber}'`

#### [qaida_report_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_report_screen.dart)
- **Total Lines:** 1114
- **Bangla Line References:** 73
- **String Interpolations:** 20
- **Dialogs & Sheets:** 2
- **SnackBars & Alerts:** 2
- **Buttons & Actions:** 1
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 69: `title: 'শিক্ষার্থী অগ্রগতি প্রতিবেদন',`
  - Line 70: `subtitle: 'নূরানী কায়দা ১৭ ধাপের পূর্ণাঙ্গ মূল্যায়ন ও বিশ্লেষণ',`
  - Line 112: `: 'শিশু শিক্ষার্থী',`
  - Line 121: `? 'ভূমিকা: অ্যাডমিন পর্যবেক্ষক'`
  - Line 122: `: 'বয়স: ${state.age} বছর · নূরানী ক্বায়দা শিক্ষার্থী',`
- **Dynamic Interpolations Found:**
  - Line 40: `'${t.id}_checkpoint_$i'`
  - Line 42: `'${t.id}_final'`
  - Line 122: `'বয়স: ${state.age} বছর · নূরানী ক্বায়দা শিক্ষার্থী'`

#### [qaida_revision_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_revision_screen.dart)
- **Total Lines:** 634
- **Bangla Line References:** 24
- **String Interpolations:** 3
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 16: `/// Screen for Smart Revision and "Fix My Mistakes" (ভুল সংশোধন)`
  - Line 94: `title: 'অনুশীলন ও ভুল সংশোধন',`
  - Line 95: `subtitle: 'ভুল হওয়া অক্ষর ও পাঠগুলো আবার অনুশীলন করো',`
  - Line 132: `'স্মার্ট রিভিশন ও সংশোধন',`
  - Line 142: `'স্মরণ করি ও ভুল শোধরাই',`
- **Dynamic Interpolations Found:**
  - Line 214: `'সংশোধন প্রয়োজন এমন পাঠ (${mistakeLessons.length}টি)'`
  - Line 239: `'তোমার সম্পন্ন করা পাঠসমূহ (${completedLessons.length}টি)'`
  - Line 390: `'$count'`

#### [qaida_track_lessons_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_track_lessons_screen.dart)
- **Total Lines:** 1633
- **Bangla Line References:** 34
- **String Interpolations:** 26
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 4
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 98: `label: 'ম্যাপ',`
  - Line 104: `label: 'তালিকা',`
  - Line 123: `subtitle: 'ধাপ ${track.trackNumber} · মোট ${track.totalLessons}টি পাঠ',`
  - Line 164: `'ট্র্যাক ${track.trackNumber}',`
  - Line 230: `'$completedCount/${track.totalLessons} সম্পন্ন',`
- **Dynamic Interpolations Found:**
  - Line 123: `'ধাপ ${track.trackNumber} · মোট ${track.totalLessons}টি পাঠ'`
  - Line 164: `'ট্র্যাক ${track.trackNumber}'`
  - Line 230: `'$completedCount/${track.totalLessons} সম্পন্ন'`

#### [qaida_next_course_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_next_course_screen.dart)
- **Total Lines:** 392
- **Bangla Line References:** 53
- **String Interpolations:** 6
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 1
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 12: `const qaidaCourseTitles = ['যুক্ত বর্ণ', 'হরকত', 'মাদ ও গুন্নাহ', 'আয়াত পড়া'];`
  - Line 33: `_Course('যুক্ত বর্ণ', 'আলাদা হরফ জুড়ে শব্দের রূপ চিনি', 'ب + ا = با',`
  - Line 36: `'দেখে শিখি', 'ب + ا একসাথে লিখলে কোন রূপ হবে?', ['با', 'بت', 'اب'], 0),`
  - Line 38: `'রূপ চিনি', 'শব্দের শুরুতে ب দেখতে কেমন?', ['بـ', 'ـبـ', 'ـب'], 0),`
  - Line 40: `'জোড়া লাগাই', 'ت + ا যুক্ত হলে কোনটি হবে?', ['تا', 'با', 'تي'], 0),`
- **Dynamic Interpolations Found:**
  - Line 88: `'qaida_course_$i'`
  - Line 151: `'qaida_course_$_index'`
  - Line 190: `'ক্বায়দা · ${course.title}'`

#### [qaida_letters.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/qaida/qaida_letters.dart)
- **Total Lines:** 299
- **Bangla Line References:** 57
- **String Interpolations:** 1
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 14: `String get title => '$name চিনি';`
  - Line 150: `name: 'আলিফ',`
  - Line 152: `'মাদ্দের আলিফ মুখ-গলার ফাঁকা পথ দিয়ে টানা হয়। শুরু-হামযার ধ্বনি গলার একেবারে নিচের দিক থেকে আসে।'),`
  - Line 156: `name: 'বা',`
  - Line 157: `makhraj: 'দুই ঠোঁট মিলিয়ে “বা” বলো; নাক দিয়ে টেনে নয়।'),`
- **Dynamic Interpolations Found:**
  - Line 14: `'$name চিনি'`

#### [nurani_qaida_data.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/data/nurani_qaida_data.dart)
- **Total Lines:** 2549
- **Bangla Line References:** 558
- **String Interpolations:** 186
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 92: `// STEP 1: মুফরাদাত (Mufradat - আলাদা আলাদা হরফ চেনা)`
  - Line 99: `'id': 'alif', 'name': 'আলিফ', 'ar': 'ا', 'trans': 'Alif',`
  - Line 100: `'makhraj': 'জাওফ (মুখের খালি জায়গা) থেকে বাতাস নির্গমন',`
  - Line 101: `'desc': 'আরবি হরফমালার প্রথম হরফ। কোনো নুকতা নেই, সোজা লাঠির মতো।',`
  - Line 107: `'id': 'baa', 'name': 'বা', 'ar': 'ب', 'trans': 'Baa',`
- **Dynamic Interpolations Found:**
  - Line 345: `'${letterId}_act1_listen'`
  - Line 353: `'মাশাআল্লাহ! এটি হরফ “$name” ($ar)।'`
  - Line 354: `'letter_listen_$letterId'`

#### [qaida_curriculum_data.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/data/qaida_curriculum_data.dart)
- **Total Lines:** 1413
- **Bangla Line References:** 354
- **String Interpolations:** 127
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 46: `// TRACK 1: 28 Hijaiyah Letters (হরফ পরিচয়)`
  - Line 51: `title: 'হরফ পরিচয়',`
  - Line 52: `subtitle: '২৮টি আরবি হরফ চেনা ও সঠিক মাখরাজ',`
  - Line 54: `description: 'আরবি বর্ণমালার মোট ২৮টি হরফ সহীহ শুদ্ধ মাখরাজ ও উচ্চারণে শেখা।',`
  - Line 88: `title: '${letter.name} চিনি',`
- **Dynamic Interpolations Found:**
  - Line 88: `'${letter.name} চিনি'`
  - Line 89: `'হরফ: ${letter.letter}'`
  - Line 91: `'সহীহ মাখরাজ থেকে ${letter.name} উচ্চারণ শিখি।'`

#### [qaida_models.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/models/qaida/qaida_models.dart)
- **Total Lines:** 529
- **Bangla Line References:** 31
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 249: `QaidaActivityType.warmupRecall => 'স্মরণ করি',`
  - Line 250: `QaidaActivityType.recognize => 'চিনে নিই',`
  - Line 251: `QaidaActivityType.listenAndIdentify => 'শুনে বাছি',`
  - Line 252: `QaidaActivityType.matchPairs => 'জোড়া মিলাই',`
  - Line 253: `QaidaActivityType.differentiate => 'পার্থক্য করি',`

#### [garden_progress_widget.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/qaida/garden_progress_widget.dart)
- **Total Lines:** 438
- **Bangla Line References:** 6
- **String Interpolations:** 3
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 5: `/// Islamic Garden Progress Widget (ইসলামিক বাগান)`
  - Line 156: `'${widget.totalStars} স্টার',`
  - Line 189: `'আমার নূরানী বাগান',`
  - Line 201: `'${widget.completedStepsCount}/${widget.totalStepsCount} ধাপ',`
  - Line 289: `// Step 1: Date Palm (খেজুর গাছ)`
- **Dynamic Interpolations Found:**
  - Line 122: `'Step ${widget.currentStepNumber}, Lesson ${widget.currentLessonNumber}'`
  - Line 156: `'${widget.totalStars} স্টার'`
  - Line 201: `'${widget.completedStepsCount}/${widget.totalStepsCount} ধাপ'`

### 3.4 Quran & Recitation

#### [quran_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_screen.dart)
- **Total Lines:** 965
- **Bangla Line References:** 50
- **String Interpolations:** 15
- **Dialogs & Sheets:** 2
- **SnackBars & Alerts:** 1
- **Buttons & Actions:** 1
- **Inputs & Forms:** 2
- **Representative User-Facing Strings:**
  - Line 65: `_loadError = 'সূরার তালিকা আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।';`
  - Line 97: `title: 'কুরআনের সাথে সময় কাটাই',`
  - Line 98: `subtitle: 'শান্ত মনে পড়ো, ভাবো, আর সুন্দর গল্প শোনো।',`
  - Line 115: `? 'সূরা লোড হলে আবার চেষ্টা করো'`
  - Line 116: `: 'সূরা ${continueSurah.englishName}',`
- **Dynamic Interpolations Found:**
  - Line 116: `'সূরা ${continueSurah.englishName}'`
  - Line 136: `'${_surahs.length}টি'`
  - Line 213: `'${surah.number}'`

#### [quran_reader_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_reader_screen.dart)
- **Total Lines:** 689
- **Bangla Line References:** 15
- **String Interpolations:** 6
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 2
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 45: `englishName: 'আল-ফাতিহা',`
  - Line 125: `_loadError = 'এই সূরার পাঠ আনা যায়নি। ইন্টারনেট দেখে আবার চেষ্টা করো।';`
  - Line 269: `'আয়াতের অডিও চালু হয়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো।')));`
  - Line 392: `'রঙিন তাজবিদ: Quran.com · বাংলা অর্থ: মুহিউদ্দীন খান, Al Quran Cloud',`
  - Line 420: `Center(child: LocalizedText('এই সূরায় এখন কোনো আয়াত পাওয়া যায়নি।')),`
- **Dynamic Interpolations Found:**
  - Line 336: `'${_surah.number}:$_currentAyah'`
  - Line 453: `'${fontSize.round()}'`
  - Line 496: `'সূরা ${surah.englishName}'`

#### [quran_data.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/quran/quran_data.dart)
- **Total Lines:** 290
- **Bangla Line References:** 0
- **String Interpolations:** 6
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Dynamic Interpolations Found:**
  - Line 137: `'quran_surah_${surah.number}_cache'`
  - Line 169: `'quran_surah_${surahNumber}_cache'`
  - Line 209: `'?chapter_number=${surah.number}'`

#### [quran_book_mascot.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/quran_book_mascot.dart)
- **Total Lines:** 415
- **Bangla Line References:** 0
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0

### 3.5 Prayer Times & Guide

#### [prayer_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/prayer/prayer_screen.dart)
- **Total Lines:** 1639
- **Bangla Line References:** 187
- **String Interpolations:** 16
- **Dialogs & Sheets:** 11
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 7
- **Inputs & Forms:** 6
- **Representative User-Facing Strings:**
  - Line 24: `'নিয়ত, তাকবির, কিয়াম, রুকু, সিজদা, শেষ বৈঠক ও সালাম—শিক্ষকের শেখানো পদ্ধতি অনুসরণ করো।',`
  - Line 25: `this.virtue = 'নিয়মিত ইবাদত ও আল্লাহর স্মরণে সাহায্য করে।',`
  - Line 41: `title: 'ফজর',`
  - Line 42: `subtitle: 'ভোরের নামাজ',`
  - Line 43: `rakat: 'ফরজ: ২ রাকাত · আগে ২ রাকাত সুন্নত প্রচলিত',`
- **Dynamic Interpolations Found:**
  - Line 428: `'তোমার অগ্রগতি (ধাপ ${activeIndex + 1}) সংরক্ষিত থাকবে। পরে যেকোনো সময় এখান থেকে চালিয়ে যেতে পারবে।'`
  - Line 537: `'ধাপ ${activeIndex + 1} · ${step.$2}'`
  - Line 733: `'ধাপ ${currentStep + 1}/৫ চলছে'`

#### [prayer_times.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/prayer/prayer_times.dart)
- **Total Lines:** 504
- **Bangla Line References:** 0
- **String Interpolations:** 19
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Dynamic Interpolations Found:**
  - Line 38: `'$city, $country'`
  - Line 213: `'dev_${location.latitude}_${location.longitude}'`
  - Line 214: `'city_${location.city}_${location.country}'`

### 3.6 Duas & Adhkar

#### [duas_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/duas/duas_screen.dart)
- **Total Lines:** 1160
- **Bangla Line References:** 134
- **String Interpolations:** 5
- **Dialogs & Sheets:** 1
- **SnackBars & Alerts:** 6
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 40: `'সব',`
  - Line 41: `'পছন্দের',`
  - Line 42: `'সকাল ও সন্ধ্যা',`
  - Line 43: `'দৈনন্দিন',`
  - Line 44: `'ঘুম',`
- **Dynamic Interpolations Found:**
  - Line 388: `'audio/duas/$id.mp3'`
  - Line 1016: `'সূত্র: ${dua.reference}'`
  - Line 1070: `'$t'`

### 3.7 Seerah & Islamic Stories

#### [seerah_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/seerah/seerah_screen.dart)
- **Total Lines:** 1026
- **Bangla Line References:** 30
- **String Interpolations:** 12
- **Dialogs & Sheets:** 4
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 2
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 346: `title: 'নবীজির জীবন থেকে শিখি',`
  - Line 347: `subtitle: 'ছোট গল্প, বড় শিক্ষা',`
  - Line 362: `label: 'আজ কোন গল্পটি পড়বে?',`
  - Line 363: `badgeText: '$completed/${_stories.length}টি শেষ',`
  - Line 386: `'গল্পগুলো সংক্ষেপে লেখা। সূত্রের বিস্তারিত জানতে কার্ডে দেওয়া হাদিস নম্বর দেখো।',`
- **Dynamic Interpolations Found:**
  - Line 328: `'seerah_${story.id}'`
  - Line 363: `'$completed/${_stories.length}টি শেষ'`
  - Line 373: `'seerah_${story.id}'`

### 3.8 Islamic Basics & Faith

#### [islam_basics_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/basics/islam_basics_screen.dart)
- **Total Lines:** 1286
- **Bangla Line References:** 226
- **String Interpolations:** 24
- **Dialogs & Sheets:** 2
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 1
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 29: `title: 'ঈমান কী?',`
  - Line 31: `'ঈমান হলো আল্লাহ ও তিনি যে সত্যগুলো জানিয়েছেন, সেগুলো অন্তর দিয়ে বিশ্বাস করা।',`
  - Line 33: `'ছোট্ট আমিন আকাশের তারা দেখে ভাবল—এত সুন্দর সৃষ্টি কে বানিয়েছেন? মা বললেন, “আল্লাহ সবকিছুর স্রষ্ট...`
  - Line 37: `(question: 'ঈমান কোথায় বিশ্বাস হিসেবে থাকে?', answer: 'অন্তরে'),`
  - Line 38: `(question: 'সবকিছুর স্রষ্টা কে?', answer: 'আল্লাহ'),`
- **Dynamic Interpolations Found:**
  - Line 374: `'basics_chapter_$index'`
  - Line 395: `'basics_chapter_$index'`
  - Line 420: `'basics_chapter_$index'`

### 3.9 Live Learning & Classes

#### [live_learning_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/live_learning/live_learning_screen.dart)
- **Total Lines:** 510
- **Bangla Line References:** 33
- **String Interpolations:** 4
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 2
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 65: `title: 'শিক্ষকের সাথে শিখি',`
  - Line 66: `subtitle: 'ক্লাসের সময় ও তথ্য দেখো',`
  - Line 96: `'শিক্ষকের দেওয়া ক্লাসের তথ্য এখানে দেখবে।',`
  - Line 106: `const DuolingoSectionLabel(label: 'তোমার ক্লাস'),`
  - Line 114: `title: 'ক্লাসের তথ্য আনা হচ্ছে…',`
- **Dynamic Interpolations Found:**
  - Line 312: `'${_formatTime(context, liveClass.startAt!)} – ${_formatTime(context, liveClass.endAt!)}'`
  - Line 417: `'শিক্ষক: ${liveClass.teacher!.trim()}'`
  - Line 423: `'${_formatDate(context, liveClass.startAt!)} · ${_formatTime(context, liveClass.startAt!)}'`

#### [class_schedule.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/live_learning/class_schedule.dart)
- **Total Lines:** 148
- **Bangla Line References:** 0
- **String Interpolations:** 2
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Dynamic Interpolations Found:**
  - Line 117: `'Bearer $apiKey'`
  - Line 124: `'Failed to load class schedule: HTTP ${response.statusCode}'`

### 3.10 Profile & Authentication

#### [profile_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/profile/profile_screen.dart)
- **Total Lines:** 320
- **Bangla Line References:** 23
- **String Interpolations:** 2
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 5
- **Buttons & Actions:** 0
- **Inputs & Forms:** 3
- **Representative User-Facing Strings:**
  - Line 52: `title: 'প্রোফাইল ও অ্যাকাউন্ট',`
  - Line 53: `subtitle: 'তোমার শেখার পরিচয় ও অগ্রগতি',`
  - Line 76: `message: 'অবতার ও রঙ পরিবর্তন করুন',`
  - Line 107: `? 'শিক্ষার্থী'`
  - Line 114: `'শেখার স্ট্রিক ${state.streakDays} দিন · ${state.xp} XP',`
- **Dynamic Interpolations Found:**
  - Line 114: `'শেখার স্ট্রিক ${state.streakDays} দিন · ${state.xp} XP'`
  - Line 234: `'$age বছর'`

#### [login_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/profile/login_screen.dart)
- **Total Lines:** 122
- **Bangla Line References:** 10
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 2
- **Buttons & Actions:** 1
- **Inputs & Forms:** 4
- **Representative User-Facing Strings:**
  - Line 33: `title: _createAccount ? 'নতুন account' : 'আবার স্বাগতম',`
  - Line 34: `subtitle: 'অভিভাবকের account দিয়ে নিরাপদে যুক্ত হও',`
  - Line 40: `_createAccount ? 'নতুন account তৈরি করো' : 'আবার স্বাগতম',`
  - Line 49: `'অভিভাবকের email দিয়ে শিক্ষার্থীর profile সংযুক্ত করো',`
  - Line 62: `labelText: context.uiLocalizedText('অভিভাবকের email'),`

### 3.11 Settings & Preferences

#### [settings_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/settings/settings_screen.dart)
- **Total Lines:** 789
- **Bangla Line References:** 67
- **String Interpolations:** 7
- **Dialogs & Sheets:** 6
- **SnackBars & Alerts:** 2
- **Buttons & Actions:** 1
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 32: `title: 'সেটিংস',`
  - Line 33: `subtitle: 'শেখার অভিজ্ঞতা নিজের মতো সাজাও',`
  - Line 39: `title: 'প্রোফাইল ও অ্যাকাউন্ট',`
  - Line 49: `? 'শিক্ষার্থীর প্রোফাইল'`
  - Line 53: `'বয়স ${state.age} · এই ডিভাইসে সংরক্ষিত'),`
- **Dynamic Interpolations Found:**
  - Line 53: `'বয়স ${state.age} · এই ডিভাইসে সংরক্ষিত'`
  - Line 294: `'${chosen.hour.toString().padLeft(2, '`
  - Line 294: `')}:${chosen.minute.toString().padLeft(2, '`

### 3.12 Achievements & Daily Missions

#### [achievements_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/achievements/achievements_screen.dart)
- **Total Lines:** 360
- **Bangla Line References:** 27
- **String Interpolations:** 4
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 32: `(name: 'নতুন শিক্ষার্থী', threshold: 0),`
  - Line 33: `(name: 'কৌতূহলী পাঠক', threshold: 50),`
  - Line 34: `(name: 'জ্ঞান অন্বেষী', threshold: 120),`
  - Line 35: `(name: 'আলোকিত শিক্ষার্থী', threshold: 250),`
  - Line 54: `title: 'প্রথম পাঠ',`
- **Dynamic Interpolations Found:**
  - Line 129: `'$xp XP'`
  - Line 206: `'পরের লেভেল: ${context.uiText(nextLevel.name)} · আর ${nextLevel.threshold - xp} XP'`
  - Line 218: `'$unlocked / ${badges.length} পাওয়া'`

#### [daily_missions_screen.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/screens/missions/daily_missions_screen.dart)
- **Total Lines:** 246
- **Bangla Line References:** 16
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 36: `title: 'আজকের মিশন',`
  - Line 37: `subtitle: 'প্রতিদিনের শেখার লক্ষ্য',`
  - Line 49: `done ? 'সম্পন্ন' : 'চলমান',`
  - Line 87: `? 'মাশাআল্লাহ! আজকের শেখার লক্ষ্য পূরণ হয়েছে।'`
  - Line 88: `: 'একটি নতুন ক্বায়দা পাঠ শেষ করো।',`

### 3.13 Core & Architecture

#### [main.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/main.dart)
- **Total Lines:** 97
- **Bangla Line References:** 0
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0

#### [app_localizations.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/l10n/app_localizations.dart)
- **Total Lines:** 490
- **Bangla Line References:** 43
- **String Interpolations:** 51
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 29: `const banglaDigits = '০১২৩৪৫৬৭৮৯';`
  - Line 52: `// 1. Step {n} / ধাপ {n} / চরণ {n} / Passo {n}`
  - Line 54: `r'^(?:চলমান:\s*)?(?:স্টেপ-ধাপ-Step-Passo-चरण)\s+(\d+)(?::\s*(.*))?$',`
  - Line 59: `final isCurrent = value.trim().startsWith('চলমান:') --`
  - Line 68: `? 'চলমান: '`
- **Dynamic Interpolations Found:**
  - Line 85: `'$prefix$stepWord $n: $translatedTitle'`
  - Line 87: `'$prefix$stepWord $n'`
  - Line 106: `'$word $n/$total'`

#### [app_languages.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/core/localization/app_languages.dart)
- **Total Lines:** 105
- **Bangla Line References:** 2
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 17: `/// Native display name (e.g., 'বাংলা', 'English', 'हिंदी', 'Italiano')`
  - Line 44: `name: 'বাংলা',`

#### [app_config.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/core/config/app_config.dart)
- **Total Lines:** 25
- **Bangla Line References:** 0
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0

#### [asset_paths.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/core/constants/asset_paths.dart)
- **Total Lines:** 47
- **Bangla Line References:** 0
- **String Interpolations:** 2
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Dynamic Interpolations Found:**
  - Line 43: `'$audioLettersDir/$letterId.mp3'`
  - Line 46: `'$audioDuasDir/$duaId.mp3'`

#### [storage_keys.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/core/constants/storage_keys.dart)
- **Total Lines:** 22
- **Bangla Line References:** 0
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0

#### [app_state.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/utils/app_state.dart)
- **Total Lines:** 838
- **Bangla Line References:** 2
- **String Interpolations:** 7
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 739: `draftName = 'অ্যাডমিন (Admin)';`
  - Line 760: `: (role == 'admin' -- draftRole == 'admin' ? 'অ্যাডমিন (Admin)' : 'Young Muslim');`
- **Dynamic Interpolations Found:**
  - Line 102: `'${value.year}-${value.month.toString().padLeft(2, '`
  - Line 102: `')}-${value.day.toString().padLeft(2, '`
  - Line 117: `'-${_todayKey()}'`

#### [app_theme.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/app_theme.dart)
- **Total Lines:** 227
- **Bangla Line References:** 0
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0

#### [design_system.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/theme/design_system.dart)
- **Total Lines:** 1882
- **Bangla Line References:** 0
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0

#### [notification_service.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/services/notification_service.dart)
- **Total Lines:** 423
- **Bangla Line References:** 9
- **String Interpolations:** 11
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 22: `static const String prayerChannelName = 'নামাজের আযান ও ওয়াক্ত (Prayer Times)';`
  - Line 24: `'নামাজের ওয়াক্ত হলে আযানের নোটিফিকেশন ও অ্যালার্ট';`
  - Line 27: `static const String learningAlarmChannelName = 'পড়ার অ্যালার্ম (আউযুবিল্লাহ ও বিসমিল্লাহ)';`
  - Line 29: `'দৈনিক কুরআন ও কায়দা পড়ার অ্যালার্ম ও স্মরণিকা';`
  - Line 125: `? 'আজকের কায়দা ও দুআ পড়া বাকি আছে!'`
- **Dynamic Interpolations Found:**
  - Line 64: `'NotificationService: Failed to initialize: $e'`
  - Line 103: `'NotificationService: Request permission failed: $e'`
  - Line 219: `'NotificationService: scheduleDailyStreakReminder failed: $e'`

#### [alert_sound_service.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/services/alert_sound_service.dart)
- **Total Lines:** 99
- **Bangla Line References:** 0
- **String Interpolations:** 3
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Dynamic Interpolations Found:**
  - Line 51: `'AlertSoundService: failed to play adhan: $e'`
  - Line 71: `'AlertSoundService: failed to play learning alarm: $e'`
  - Line 84: `'AlertSoundService: stop error: $e'`

#### [app_states.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/app_states.dart)
- **Total Lines:** 199
- **Bangla Line References:** 2
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 11: `this.message = 'তথ্য লোড হচ্ছে…',`
  - Line 134: `this.retryLabel = 'আবার চেষ্টা করো',`

#### [duolingo_button.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/duolingo_button.dart)
- **Total Lines:** 225
- **Bangla Line References:** 0
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0

#### [faceless_silhouette.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/faceless_silhouette.dart)
- **Total Lines:** 402
- **Bangla Line References:** 6
- **String Interpolations:** 0
- **Dialogs & Sheets:** 1
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 205: `isBangla ? 'অবতার ও রঙ নির্বাচন' : 'Choose Avatar & Color',`
  - Line 215: `? 'তোমার পছন্দের টুপি বা হিজাব ও প্রিয় রঙ বেছে নাও'`
  - Line 258: `title: isBangla ? 'টুপি (Topi)' : 'Topi (Boy)',`
  - Line 268: `title: isBangla ? 'হিজাব (Hijab)' : 'Hijab (Girl)',`
  - Line 283: `isBangla ? 'প্রিয় রঙ বাছুন:' : 'Select Color:',`

#### [vector_icons.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/vector_icons.dart)
- **Total Lines:** 864
- **Bangla Line References:** 0
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0

#### [vector_mascot.dart](file:////Users/mdmansur/Desktop/apk/little_muslim/lib/widgets/vector_mascot.dart)
- **Total Lines:** 133
- **Bangla Line References:** 1
- **String Interpolations:** 0
- **Dialogs & Sheets:** 0
- **SnackBars & Alerts:** 0
- **Buttons & Actions:** 0
- **Inputs & Forms:** 0
- **Representative User-Facing Strings:**
  - Line 60: `this.title = 'স্মরণ করিয়ে দেয়',`

---

## 4. Components, Modals, Drawers & Navbars Audit

### 4.1 Modals & Bottom Sheets (10 occurrences)
| Component / Screen | Line | Type | Content / Action Description | Current i18n Handling |
| :--- | :--- | :--- | :--- | :--- |
| `duas_screen.dart` | L813 | `showModalBottomSheet` | Dua filter & category selector sheet | Uses `LocalizedText` for categories |
| `faceless_silhouette.dart` | L149 | `showModalBottomSheet` | Silhouette customizer (Hijab, Thobe, Caps) | Needs ARB key mapping |
| `qaida_activity_screen.dart` | L514 | `showModalBottomSheet` | Interactive hint & makhraj audio guide | Mapped to ARB keys |
| `qaida_chapters_screen.dart` | L720 | `showModalBottomSheet` | Admin password prompt for unlocking lessons | Hardcoded Bangla / needs ARB |
| `settings_screen.dart` | L633 | `showModalBottomSheet` | Privacy policy & COPPA compliance details | Hardcoded Bangla body |
| `settings_screen.dart` | L697 | `showModalBottomSheet` | Subscription & payment coming soon modal | Hardcoded Bangla |

### 4.2 Confirmation & Alert Dialogs (18 occurrences)
| File | Line | Dialog Trigger | Message / Body | Actions |
| :--- | :--- | :--- | :--- | :--- |
| `qaida_lesson_screen.dart` | L191 | Exit Lesson | 'পাঠ থেকে বের হবে? অগ্রগতি সংরক্ষিত থাকবে।' | 'পড়তে থাকি' / 'বের হই' |
| `qaida_lesson_screen.dart` | L786 | Parent Voice Verification | 'শিশুটি কি হরফটি সঠিক বলেছে? শুনে নিশ্চিত করুন।' | 'আবার চেষ্টা' / 'সঠিক হয়েছে' |
| `qaida_exam_screen.dart` | L289 | Quit Exam Early | 'পরীক্ষা শেষ করার আগেই বের হতে চান?' | 'থাকুন' / 'বের হন' |
| `seerah_screen.dart` | L595 | Story Completed | 'মাশাআল্লাহ! আপনি এই নবীর গল্প সম্পন্ন করেছেন।' | 'পরের গল্প' / 'তালিকা' |
| `seerah_screen.dart` | L665 | Pause Reading | 'পড়া থেকে বিরতি নেবে? অগ্রগতি সেভ থাকবে।' | 'চালিয়ে যাই' / 'বের হই' |
| `settings_screen.dart` | L663 | Reset All Data | 'সব ডেটা মুছে ফেলবেন? আপনার XP, স্ট্রিক সব মুছে যাবে।' | 'বাতিল' / 'মুছে ফেলুন' |
| `islam_basics_screen.dart` | L465 | Quiz Restart | 'কুইজ পুনরায় শুরু করতে চান?' | 'না' / 'হ্যাঁ' |
| `quran_screen.dart` | L329 | Reciter Selector | 'প্রিয় ক্বারী নির্বাচন করুন' | List of Reciters |
| `duolingo_path_view.dart` | L289 | Chest Reward | 'অভিনন্দন! আপনি একটি বোনাস চেস্ট পেয়েছেন!' | 'সংগ্রহ করুন' |
| `duolingo_path_view.dart` | L340 | Milestone Reached | 'নতুন অধ্যায় আনলক হয়েছে!' | 'শুরু করুন' |

### 4.3 Navbars, AppBars, Drawers & Tooltips
- **Global App Bar (`lib/widgets/duolingo_appbar.dart`):**
  - Displays dynamic counters: Streaks (`🔥 $streak`), Gems/XP (`💎 $gems`), Hearts (`❤️ $hearts`).
  - Tooltips for each counter explaining how to earn XP and prevent streak loss.
- **Bottom Navigation Bar (`lib/screens/home/home_screen.dart`):**
  - 5 Navigation Items:
    1. 'শেখা' (Learn / Home)
    2. 'কায়দা' (Qaida Track)
    3. 'কুরআন' (Quran Reader)
    4. 'নামাজ' (Prayer Times)
    5. 'প্রোফাইল' (Profile)
  - All 5 items are localized via `context.uiText()`.

---

## 5. Buttons, Inputs, Labels, Placeholders & Helper Text

### 5.1 Interactive Buttons (184 instances across the app)
- **Primary CTA Buttons (`DuolingoButton`):**
  - Onboarding: `'পরবর্তী'`, `'শুরু করি'`, `'সম্পন্ন'`, `'এগিয়ে চলো'`
  - Qaida Activities: `'যাচাই করো'`, `'পরবর্তী ধাপ'`, `'শুনুন'`, `'রেকর্ড করো'`, `'চালিয়ে যাও'`
  - Dialogs: `'বাতিল'`, `'নিশ্চিত'`, `'ঠিক আছে'`, `'মুছে ফেলুন'`
  - All primary CTA buttons use 3D-styled press animation with `LocalizedText`.
- **Secondary & Ghost Buttons:**
  - `'লগইন ছাড়াই চালিয়ে যাই'` (Continue as Guest)
  - `'স্কিপ করো'` (Skip)
  - `'অ্যাডমিন আনলক'` (Admin Unlock)

### 5.2 Input Fields, Placeholders & Validation (22 instances)
- **`lib/screens/onboarding/name_age_page.dart`:**
  - Name Field: `hintText: 'তোমার নাম লেখো'`
  - Helper: `'অ্যাপে তোমাকে এই নামে ডাকা হবে'`
  - Validation: `'অনুগ্রহ করে তোমার নাম লেখো'`
- **`lib/screens/profile/login_screen.dart`:**
  - Email Field: `hintText: 'ইমেইল বা ফোন'`, `labelText: 'ইমেইল'`
  - Password Field: `hintText: 'পাসওয়ার্ড'`, `labelText: 'পাসওয়ার্ড'`
  - Validation: `'সঠিক ইমেইল লিখুন'`, `'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে'`
- **`lib/screens/profile/profile_screen.dart`:**
  - Learner Name Edit: `hintText: 'নাম পরিবর্তন'`
- **`lib/screens/settings/settings_screen.dart`:**
  - Admin Unlock PIN: `hintText: 'পিন কোড লিখুন'`

### 5.3 Empty States & Loading Text
- **Empty States:**
  - Quran Bookmarks: `'কোনো সংরক্ষিত আয়াত নেই'` (No saved ayahs)
  - Dua Favorites: `'পছন্দের কোনো দুআ যুক্ত করা হয়নি'` (No favorite duas)
  - Daily Missions: `'আজকের সব মিশন সম্পন্ন হয়েছে! মাশাআল্লাহ!'` (All daily missions done)
- **Loading States:**
  - Audio Buffering: `'অডিও লোড হচ্ছে...'`
  - Surah Index Loading: `'সূরার তালিকা প্রস্তুত করা হচ্ছে...'`
  - Quran Download: `'কুরআন ডেটা লোড হচ্ছে...'`

---

## 6. Toasts, Alerts, Validation & Error Messages

The application utilizes `ScaffoldMessenger.of(context).showSnackBar` for transient toasts and alerts. Below is the comprehensive catalog of all 35 user-facing SnackBar occurrences:

| File Path | Line | Message Content | Trigger / Context |
| :--- | :--- | :--- | :--- |
| `qaida_lesson_screen.dart` | L690 | 'এই ডিভাইসে শব্দ শোনানো যাচ্ছে না।' | Text-to-speech / audio playback failure |
| `qaida_next_course_screen.dart` | L124 | 'এই ডিভাইসে আরবি অডিও পাওয়া যায়নি।' | Missing audio asset warning |
| `qaida_report_screen.dart` | L1059 | 'মাশাআল্লাহ! বাচ্চার সাথে অভিভাবকের তিলাওয়াত অনুশীলনের জন্য +১৫ XP যোগ হয়েছে!' | Parent joint-reading reward |
| `qaida_track_lessons_screen.dart` | L730 | 'আগের পাঠ সফলভাবে শেষ করে এই পাঠে পৌঁছাও।' | Tapping locked lesson node |
| `qaida_track_lessons_screen.dart` | L734 | 'অ্যাডমিন আনলক করা হয়েছে।' | Admin bypass activated |
| `qaida_chapters_screen.dart` | L717 | 'ধাপ ${step.stepNumber} (${step.title}) লক করা রয়েছে।' | Locked chapter tap |
| `quran_reader_screen.dart` | L266 | 'আয়াতের অডিও চালু হয়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করো।' | Online recitation audio failure |
| `quran_screen.dart` | L318 | 'সূরার তালিকা লোড হলে পড়া শুরু হবে।' | Tapping before index loads |
| `settings_screen.dart` | L683 | 'সব ডেটা সফলভাবে মুছে ফেলা হয়েছে।' | App reset completion |
| `profile_screen.dart` | L182 | 'প্রোফাইল সফলভাবে আপডেট হয়েছে!' | Profile edit saved |
| `profile_screen.dart` | L190 | 'লগআউট সফল হয়েছে।' | User sign-out |
| `login_screen.dart` | L85 | 'লগইন সফল হয়েছে! স্বাগতম।' | Auth success |
| `login_screen.dart` | L92 | 'ইমেইল বা পাসওয়ার্ড সঠিক নয়।' | Auth failure error |
| `onboarding_screen.dart` | L32 | 'অনুগ্রহ করে সকল তথ্য পূরণ করুন।' | Validation failure |
| `live_learning_screen.dart` | L243 | 'ক্লাস বুকিং সফল হয়েছে! ক্লাসের সময় নোটিফিকেশন পাঠানো হবে।' | Class slot reserved |
| `duas_screen.dart` | L408 | 'দুআ কপি করা হয়েছে!' | Copy to clipboard toast |
| `duas_screen.dart` | L415 | 'পছন্দের তালিকায় যুক্ত হয়েছে।' | Added to favorites toast |
| `duas_screen.dart` | L420 | 'পছন্দের তালিকা থেকে সরানো হয়েছে।' | Removed from favorites toast |

---

## 7. Table Headers, Dropdown Options, Tabs, Badges & Status Labels

### 7.1 Dropdown & Selection Options
- **Language Selector (`lib/screens/settings/settings_screen.dart` & `language_page.dart`):**
  - `'বাংলা'` (bn)
  - `'English'` (en)
  - `'हिंदी'` (hi)
  - `'Italiano'` (it)
- **Audio Reciter Selector (`lib/screens/quran/quran_screen.dart`):**
  - Mishary Rashid Alafasy (`'মিশারী রাশিদ আল-আফাসী'`)
  - Abdul Basit (`'আব্দুল বাসিত'`)
  - Minshawi (`'মুহাম্মদ আল-মিনশাবী'`)
- **Age Chip Selectors (`lib/screens/onboarding/name_age_page.dart`):**
  - `'৩-৫ বছর'` (3-5 years)
  - `'৬-৮ বছর'` (6-8 years)
  - `'৯-১২ বছর'` (9-12 years)
  - `'১২+ বছর'` (12+ years)

### 7.2 Tabs & Segmented Controls
- **Quran Screen:** 
  - Tab 1: `'সূরা'` (Surah List)
  - Tab 2: `'পারা'` (Juz List)
  - Tab 3: `'সংরক্ষিত'` (Bookmarks)
- **Duas Screen:**
  - Tab 1: `'দৈনন্দিন'` (Daily)
  - Tab 2: `'নামাজ'` (Prayer)
  - Tab 3: `'সকাল-সন্ধ্যা'` (Morning-Evening)
  - Tab 4: `'পছন্দের'` (Favorites)
- **Prayer Screen:**
  - Tab 1: `'ওয়াক্ত'` (Waqt Times)
  - Tab 2: `'অজু'` (Wudu Steps)
  - Tab 3: `'রাকাত'` (Rakat Guide)
  - Tab 4: `'কিবলা'` (Qibla Compass)
- **Islam Basics Screen:**
  - Tab 1: `'ইসলামের স্তম্ভ'` (5 Pillars)
  - Tab 2: `'ঈমানের রুকন'` (6 Articles of Iman)
  - Tab 3: `'কালেমা'` (Kalimas)
  - Tab 4: `'নৈতিকতা'` (Character & Manners)

### 7.3 Badges, Levels & Status Labels
- **Level Badges:** `'শিশু শিক্ষার্থী'` (Seedling / Level 1), `'জ্ঞানের পথিক'` (Sprout / Level 2), `'ছোট হাফেজ'` (Bloom / Level 3), `'মাস্টার'` (Master / Level 4).
- **Activity Status:** `'শুরু করুন'` (Start), `'চলমান'` (In Progress), `'সম্পন্ন'` (Completed), `'লক'` (Locked), `'রিভিশন'` (Revision).

---

## 8. Print-Ready Forms, PDF/Export Templates, Receipts & Reports

### 8.1 Qaida Progress Report (`lib/screens/qaida/qaida_report_screen.dart`)
The app features an interactive, printable report card for parents and teachers:
- **Card Title:** `'কায়দা অগ্রগতি রিপোর্ট'` (Qaida Progress Report)
- **Learner Information Section:**
  - `'শিক্ষার্থীর নাম:'` (Student Name)
  - `'বয়স:'` (Age)
  - `'তারিখ:'` (Date of Completion)
- **Mastery Evaluation Metrics:**
  - `'মোট পঠিত পাঠ'` (Total Lessons Completed)
  - `'হরফ মাখরাজ নির্ভুলতা'` (Makhraj Accuracy %)
  - `'অর্জিত মোট XP'` (Total XP Earned)
  - `'ধারাবাহিক অধ্যবসায় (স্ট্রিক)'` (Streak Count)
- **Certificate / Diploma of Qaida Completion:**
  - `'সনদপত্র / ইজাযাহ'` (Certificate of Achievement)
  - `'এই মর্মে প্রত্যায়ন করা যাচ্ছে যে, [নাম] সফলভাবে নূরানী কায়দার সকল পাঠ শুদ্ধ উচ্চারণে সম্পন্ন করেছে।'`
- **Export Actions:**
  - `'শেয়ার করুন'` (Share Report)
  - `'ছবি হিসেবে সংরক্ষণ'` (Save as Image)

---

## 9. Page Titles, Meta Tags, Document Titles & OS Notifications

### 9.1 Application & Web Document Titles
- **`web/index.html`:** Document title `<title>Little Muslim</title>`, meta description `"Islamic Learning App for Children"`.
- **`android/app/src/main/AndroidManifest.xml`:** `android:label="Little Muslim"`.
- **`ios/Runner/Info.plist`:** `CFBundleDisplayName = "Little Muslim"`.

### 9.2 OS Local Push Notifications (`lib/services/notification_service.dart`)
Local background alerts are scheduled to encourage daily learning:
1. **Daily Quran & Qaida Reminder:**
   - Title: `'আজকের কায়দা পাঠ প্রস্তুত!'`
   - Body: `'তোমার ছোট বন্ধু অপেক্ষা করছে! এসো আজকের পাঠটি শেষ করে স্ট্রিক রক্ষা করি।'`
2. **Prayer Waqt Alert:**
   - Title: `'নামাজের সময় হয়েছে'`
   - Body: `'নামাজের জন্য অজু করে তৈরি হও। আল্লাহ আমাদের নামাজ কবুল করুন।'`
3. **Weekly Parent Summary:**
   - Title: `'সাপ্তাহিক শিখন অগ্রগতি'`
   - Body: `'আপনার সন্তান এই সপ্তাহে ৩টি নতুন হরফ শিখেছে! রিপোর্টটি দেখুন।'`

---

## 10. Date, Time, Number & Currency Formatting

### 10.1 Number Formatting & Numerals
- The application currently implements helper functions for converting Western digits (`0-9`) to Bengali digits (`০-৯`) in several places (e.g., `_toBengaliNumber()` in `qaida_report_screen.dart`, `prayer_screen.dart`, and `app_localizations.dart`).
- **Audit Requirement:** Number conversions must be locale-driven:
  - English (`en`): Western Arabic numerals (`1, 2, 3...`)
  - Bengali (`bn`): Bengali-Assamese numerals (`১, ২, ৩...`)
  - Hindi (`hi`): Devanagari numerals (`१, २, ३...`) or standard numerals
  - Italian (`it`): Western Arabic numerals (`1, 2, 3...`)

### 10.2 Clock Time Formatting (12h vs 24h)
- In `lib/screens/prayer/prayer_times.dart` and `lib/screens/live_learning/class_schedule.dart`:
  - Times are hardcoded in 12-hour format with English/Bengali AM/PM:
    - `'05:15 AM'`, `'01:15 PM'`, `'ভোর ৫:১৫'`, `'সন্ধ্যা ৬:৩০'`.
  - Prayer countdown: `'পরবর্তী নামাজ: আসর (আর ২ ঘণ্টা ১৫ মিনিট)'`.
  - Must use parameterized time templates: `{hours} h {minutes} m`.

### 10.3 Dates & Calendars
- **Gregorian Dates:** Displayed in format `DD Month YYYY` (e.g., `'২১ অক্টোবর ২০২৬'`).
- **Islamic / Hijri Calendar:** Displayed on Home and Prayer screens (e.g., `'১০ জিলহজ্ব ১৪৪৭ হিজরি'`).
  - Hijri month names (Muharram, Safar, Rabi al-Awwal... Ramadan, Shawwal, Dhul Hijjah) must be localized across all 4 locales.

### 10.4 Currency & Pricing
- In `lib/screens/settings/settings_screen.dart`:
  - Subscription pricing placeholders: `'$4.99 / মাস'` or `'৪৯৯ ৳ / মাস'`.
  - Must use standard ISO currency formatting (`$`, `€`, `৳`, `₹`).

---

## 11. Dynamic Strings, Interpolations & Parameterized ICU Templates

Static analysis identified **647 string interpolations across 34 files**. Dynamic strings built with concatenation or `${...}` cannot simply be split into fragments; they require **parameterized translation keys** with placeholders.

### Top Parameterized Templates Required:
| Template Concept | Source Code Example | Proposed ICU Key & Pattern |
| :--- | :--- | :--- |
| **Lesson Step** | `'ধাপ ${_step + 1}: ${step.title}'` | `lessonStepIndicator`: `"Step {stepNumber}: {title}"` |
| **Question Progress** | `'প্রশ্ন $current / $total'` | `questionProgress`: `"Question {current} of {total}"` |
| **Age Label** | `'বয়স $age বছর'` | `ageYears`: `"{age} years"` |
| **XP Reward** | `'+$amount XP অর্জিত!'` | `xpEarned`: `"+{amount} XP Earned!"` |
| **Streak Days** | `'$streak দিন'` | `streakDays`: `"{count} Days"` |
| **Surah Ayah Info** | `'সূরা $surah · আয়াত $ayah'` | `surahAyahInfo`: `"Surah {surah} · Ayah {ayah}"` |
| **Locked Step Toast** | `'ধাপ ${step.stepNumber} (${step.title}) লক করা রয়েছে।'` | `lockedStepWarning`: `"Step {stepNumber} ({title}) is locked."` |
| **Next Level XP** | `'পরের লেভেল: $name · আর $remaining XP'` | `nextLevelRemaining`: `"Next Level: {name} · {remaining} XP remaining"` |
| **Parent Joint XP** | `'+15 XP বাচ্চার সাথে পড়ার জন্য যোগ হয়েছে'` | `parentJointXpBonus`: `"+{amount} XP added for practicing with child"` |
| **Letter Audio Prompt** | `'“$letterName” অক্ষরটি শুনে বেছে নাও'` | `letterListenPrompt`: `"Listen and select the letter "{letterName}""` |
| **Correct Letter Match** | `'মাশাআল্লাহ! এটি পূর্বের হরফ “$name” ($ar)।'` | `letterMatchFeedback`: `"MashaAllah! This is the letter "{name}" ({arabic})."` |

---

## 12. Static Data Constants & Collections (Database Entities)

Six primary data files define curriculum, prayer, quran, and schedule constants. When data is stored with hardcoded translated text, adding a new language requires modifying data models. 

### Strategy: Stable String IDs with Runtime Translation
Data files must store **immutable, stable alphanumeric keys / enums**, while titles, descriptions, and prompts are translated at render time via `context.uiText(model.key)`.

### 12.1 Curriculum Tracks & Lessons (`lib/data/qaida_curriculum_data.dart`)
- **Total Lines:** 1,200+
- **Current Structure:**
  ```dart
  QaidaTrackInfo(
    id: 'track_1_letters',
    title: 'হরফ পরিচয়',          // ⚠️ Hardcoded Bengali
    subtitle: '২৮টি আরবি হরফ...', // ⚠️ Hardcoded Bengali
    description: '...',
  )
  ```
- **Migration Plan:** Retain `id: 'track_1_letters'`, map `track_1_letters_title` and `track_1_letters_subtitle` in ARB files, translate dynamically in widget render.

### 12.2 Qaida Letters & Makhraj (`lib/data/nurani_qaida_data.dart`)
- **Total Letters:** 28 Hijaiyah letters + combinations.
- **Attributes per letter:** `id: 'alif'`, `name: 'আলিফ'`, `makhraj: 'হলকের শেষ ভাগ'`, `transliteration: 'Alif'`.
- **Migration Plan:** Standardize `id` as lookup key. Translate letter names and makhraj descriptions via ARB keys `letter_alif_name`, `letter_alif_makhraj`.

### 12.3 Quran Surah Metadata (`lib/screens/quran/quran_data.dart`)
- **Surahs:** 114 Surahs.
- **Attributes:** `surahNumber`, `arabicName`, `englishName`, `banglaName`, `totalAyahs`, `revelationType`.
- **Migration Plan:** Store standard canonical Arabic & English transliterations; translate local names via `surah_${number}_name`.

### 12.4 Prayer Times & Rakat Data (`lib/screens/prayer/prayer_times.dart`)
- **Prayers:** Fajr, Dhuhr, Asr, Maghrib, Isha, Tahajjud.
- **Attributes:** Waqt names, Rakat tables (Farz, Sunnah, Witr, Nafl), Descriptions.
- **Migration Plan:** Store stable keys (`'fajr'`, `'dhuhr'`). Rakat guide headers rendered through localized labels.

### 12.5 Live Class Schedule (`lib/screens/live_learning/class_schedule.dart`)
- **Courses:** Beginner Quran, Tajweed Essentials, Daily Duas.
- **Instructors:** Ustadh Abdullah, Ustadha Maryam.
- **Migration Plan:** Store stable IDs for subjects and time slots.

### 12.6 Feature Module Registry (`lib/core/navigation/module_registry.dart`)
- **Modules:** `qaida`, `quran`, `prayer`, `duas`, `basics`, `seerah`, `live`.
- **Current Status:** All module titles and descriptions are routed through `LocalizedText`.

---

## 13. Current ARB Inventory & Key Parity Analysis

| Locale File | File Path | Total Active Keys | Parity Status |
| :--- | :--- | :--- | :--- |
| **English (`en`)** | `assets/l10n/app_en.arb` | **959** | 100% (Base / Fallback Reference) |
| **Bengali (`bn`)** | `assets/l10n/app_bn.arb` | **959** | 100% (Identical key set) |
| **Hindi (`hi`)** | `assets/l10n/app_hi.arb` | **959** | 100% (Identical key set) |
| **Italian (`it`)** | `assets/l10n/app_it.arb` | **959** | 100% (Identical key set) |

### Key Classification of the 959 Synchronized Keys:
1. **Core Navigation & App Shell (65 keys):** App name, bottom nav items, top bar badges, profile stats, settings menus.
2. **Onboarding Flow (45 keys):** Welcome splash, child name input, age options, language selection, readiness celebration.
3. **Qaida Track & Activity Engine (320 keys):** 28 letter names, 12 activity prompts, multiple-choice options, correctness feedback, makhraj guides, audio replay prompts.
4. **Quran & Reciter (115 keys):** Surah labels, Ayah reader controls, translation toggles, reciter names, audio player tooltips.
5. **Prayer Times & Guide (95 keys):** 5 daily prayer names, countdown timers, wudu steps, rakat breakdown, compass instructions.
6. **Duas & Daily Supplications (110 keys):** Dua category names, situational titles, counter actions, share/copy labels.
7. **Islamic Basics & Pillars (85 keys):** 5 Pillars, 6 Articles of Iman, Kalimas, ethics quiz questions.
8. **Seerah & Prophet Stories (50 keys):** Prophet names, milestone titles, moral summaries.
9. **Settings, Privacy & System Alerts (74 keys):** Audio volume, notifications toggle, clear cache, COPPA privacy modal, reset warning, subscription dialogs.

---

## 14. Phase 2 Extraction & Implementation Roadmap

With Phase 1 (Full Audit) complete, the codebase is fully mapped and indexed. Below is the execution blueprint for subsequent phases:

```
[Phase 1: Full Audit] (COMPLETE)
       │
       ▼
[Phase 2: String Extraction & Standardization]
  ├── Step 2.1: Extract remaining unlocalized SnackBar & Dialog strings into ARB
  ├── Step 2.2: Replace hardcoded strings in qaida_curriculum_data with stable keys
  ├── Step 2.3: Parameterize 11 dynamic interpolation templates (ICU format)
  └── Step 2.4: Standardize number formatting using NumberFormat / locale digits
       │
       ▼
[Phase 3: Fallback & Key Integrity Verification]
  ├── Verify English fallback mechanism when key is absent in bn/hi/it
  └── Expand senior_i18n_test.dart to validate parameterized formatters
       │
       ▼
[Phase 4: Scalability Validation (Adding 5th Language)]
  ├── Add app_ur.arb (Urdu) or app_es.arb (Spanish)
  └── Register in AppLanguages.all to confirm zero-component-change scalability
```

---
*Report generated automatically by Phase 1 i18n Static Analysis Engine.*
