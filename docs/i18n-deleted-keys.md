# Inventory of Deleted Translation Keys

This document records all **148 genuinely unused translation keys** removed from `locales/*.json`, `assets/locales/*.json`, `assets/l10n/app_*.arb`, and `lib/l10n/static_translations.dart`.

## 1. Summary by Namespace

| Namespace | Count | Rationale |
| :--- | :---: | :--- |
| `qaida` | 64 | Legacy activity prompts replaced by curriculum step prompts; unused track subtitles |
| `prayer` | 15 | Legacy calculation dropdown labels and duplicate dialog strings |
| `auth` | 10 | Replaced by active `login.*` namespace in `login_screen.dart` |
| `duas` | 7 | Legacy category tabs and duplicate empty state strings |
| `basics` | 6 | Replaced by chapter-specific title and definition keys |
| `missions` | 6 | Replaced by `missions.reward_claimed` and `profile.streak_xp` |
| `settings` | 6 | Replaced by specific `settings.*` keys used in `settings_screen.dart` |
| `onboarding` | 5 | Replaced by active `onboarding.welcome_*` and `onboarding.name_hint_examples` |
| `common` | 5 | Generic one-off labels unused across all screens |
| `app` | 4 | App name/version sourced directly from `AppConfig` |
| `live` | 4 | Replaced by `live.app_bar_title` and `live.status_*` |
| `quran` | 4 | Replaced by `quran.verse` and audio controller keys |
| `seerah` | 4 | Replaced by `seerah.lesson_learned` and `seerah.read_button` |
| `validation` | 4 | Client validation handled inline/via snackbars |
| `nav` | 3 | Replaced by module registry navigation keys |
| `misc` | 1 | Un-namespaced orphan `holyQuranRecitation` |
| **Total** | **148** | |

## 2. Complete List of 148 Deleted Keys

| # | Key | English Translation | Reason for Removal |
| :---: | :--- | :--- | :--- |
| 1 | `app.copyright` | "© 2026 Little Muslim. All rights reserved." | Generic copyright string, unused by UI widgets |
| 2 | `app.name` | "Little Muslim" | Unused string key; app title is sourced from AppConfig.appName |
| 3 | `app.tagline` | "Islamic Learning for Children" | Unused promotional tagline |
| 4 | `app.version` | "Version {{version}}" | Unused version label; settings screen displays build info directly |
| 5 | `auth.email` | "Email" | Legacy auth key; login_screen.dart uses 'login.parent_email_label' |
| 6 | `auth.guest` | "Continue as Guest" | Unused guest button key |
| 7 | `auth.login` | "Login" | Legacy auth key; login_screen.dart uses 'login.login_button' |
| 8 | `auth.login_error` | "Invalid email or password." | Legacy auth key; login_screen.dart uses 'login.service_unavailable_snack' |
| 9 | `auth.login_success` | "Login successful! Welcome." | Unused login notification message |
| 10 | `auth.logout` | "Log Out" | Legacy auth key; settings_screen.dart uses 'settings.logout' |
| 11 | `auth.parent_portal` | "Parent Portal" | Unused portal label |
| 12 | `auth.password` | "Password" | Legacy auth key; login_screen.dart uses 'login.password_label' |
| 13 | `auth.pin` | "PIN Code" | Unused PIN label |
| 14 | `auth.profile_updated` | "Profile successfully updated!" | Unused snackbar message |
| 15 | `basics.ethics` | "Manners & Character" | Legacy topic title; replaced by chapter-specific titleKeys |
| 16 | `basics.faith` | "6 Articles of Faith" | Legacy topic title; replaced by chapter-specific titleKeys |
| 17 | `basics.kalimas` | "Kalimas" | Legacy topic title; replaced by chapter-specific titleKeys |
| 18 | `basics.pillars` | "5 Pillars of Islam" | Legacy topic title; replaced by chapter-specific titleKeys |
| 19 | `basics.quiz_restart` | "Restart Quiz" | Unused quiz button key |
| 20 | `basics.title` | "Islamic Basics" | Legacy title; module_registry.dart uses 'nav.basics' |
| 21 | `common.age_years` | "{{age}} years" | Unused age formatter; app_formatters.dart formats age directly |
| 22 | `common.confirm` | "Confirm" | Unused generic button key |
| 23 | `common.done` | "Completed" | Unused generic status label |
| 24 | `common.error` | "An error occurred" | Unused generic error label |
| 25 | `common.success` | "Success" | Unused generic success label |
| 26 | `duas.counter` | "Count: {{count}}" | Unused counter label; Dua cards render digit badges directly |
| 27 | `duas.daily` | "Daily" | Legacy category tab; dynamic category filtering uses model category IDs |
| 28 | `duas.favorites` | "Favorites" | Legacy tab title; duas_screen.dart uses 'duas.favorites_empty' etc. |
| 29 | `duas.morning_evening` | "Morning & Evening" | Legacy category tab label |
| 30 | `duas.no_favorites` | "No favorite duas added yet" | Legacy empty state; duas_screen.dart uses 'duas.favorites_empty' |
| 31 | `duas.prayer_duas` | "Prayer" | Legacy category tab label |
| 32 | `duas.title` | "Duas & Adhkar" | Legacy title; module_registry.dart uses 'nav.dua' |
| 33 | `holyQuranRecitation` | "Holy Quran Recitation" | Orphaned key without namespace |
| 34 | `live.booking_success` | "Class booked successfully! Notification will be sent." | Unused dialog key |
| 35 | `live.completed` | "Completed" | Unused status filter; live_class_screen.dart uses 'live.status_completed' |
| 36 | `live.title` | "Live Class" | Legacy title; live_class_screen.dart uses 'live.app_bar_title' |
| 37 | `live.upcoming` | "Upcoming" | Unused status filter; live_class_screen.dart uses 'live.status_upcoming' |
| 38 | `missions.completed_all` | "All daily missions completed today! MashaAllah!" | Unused badge popup key |
| 39 | `missions.streak_days.one` | "1 Day" | Unused plural key; profile_screen.dart uses 'profile.streak_xp' |
| 40 | `missions.streak_days.other` | "{{count}} Days" | Unused plural key; profile_screen.dart uses 'profile.streak_xp' |
| 41 | `missions.streak_days.zero` | "0 Days" | Unused plural key; profile_screen.dart uses 'profile.streak_xp' |
| 42 | `missions.title` | "Daily Missions" | Legacy title; module_registry.dart uses 'nav.missions' |
| 43 | `missions.xp_reward` | "+{{amount}} XP" | Unused mission key; daily_missions_screen.dart uses 'missions.reward_claimed' |
| 44 | `nav.close` | "Close" | Unused nav button key |
| 45 | `nav.profile` | "Profile" | Legacy navbar key; module_registry.dart uses 'profile.title' |
| 46 | `nav.skip` | "Skip" | Unused skip button key; onboarding_screen.dart uses 'onboarding.skip' |
| 47 | `onboarding.name_placeholder` | "Enter your name" | Legacy placeholder; name_age_page.dart uses 'onboarding.name_hint_examples' |
| 48 | `onboarding.ready_subtitle` | "Let's begin your wonderful Islamic learning journey" | Legacy onboarding step subtitle |
| 49 | `onboarding.ready_title` | "You are ready!" | Legacy onboarding step title |
| 50 | `onboarding.welcome_subtitle` | "Learn Arabic letters, daily prayers, and Quran with fun games" | Legacy welcome subtitle; welcome_page.dart uses 'onboarding.welcome_tagline' |
| 51 | `onboarding.welcome_title` | "Welcome to Little Muslim" | Legacy welcome title; welcome_page.dart uses 'onboarding.welcome_heading' |
| 52 | `prayer.alerts_enabled` | "Play Adhan at prayer times" | Legacy toggle label; settings_screen.dart uses 'settings.prayer_notifications_label' |
| 53 | `prayer.asr_method_label` | "Asr method" | Legacy dropdown label; prayer_screen.dart uses 'prayer.school_shafi' / 'prayer.school_hanafi' |
| 54 | `prayer.calc_method_label` | "Calculation method" | Legacy dropdown label |
| 55 | `prayer.calc_settings` | "Calculation settings" | Legacy settings section title |
| 56 | `prayer.chapter.default_virtue` | "Helps in regular worship and remembrance of Allah." | Unused fallback virtue key |
| 57 | `prayer.city_field` | "City" | Legacy input field label; prayer_screen.dart uses 'prayer.enter_city' |
| 58 | `prayer.countdown` | "Next Prayer: {{prayer}} ({{time}} remaining)" | Legacy countdown; prayer_screen.dart uses 'prayer.next_prayer_in' |
| 59 | `prayer.country_field` | "Country" | Legacy input field label |
| 60 | `prayer.loc_permission_dialog_desc` | "Your location is used only to calculate prayer times and is sent to AlAdhan. You can enter a city instead." | Legacy duplicate of 'prayer.use_location_content' |
| 61 | `prayer.loc_permission_dialog_title` | "Use your location?" | Legacy duplicate of 'prayer.use_location_title' |
| 62 | `prayer.next_prayer` | "Next Prayer: {{prayer}} in {{time}}" | Legacy banner string; prayer_screen.dart uses 'prayer.next_prayer_in' |
| 63 | `prayer.qibla` | "Qibla Compass" | Unused feature title |
| 64 | `prayer.rakat` | "Rakat Guide" | Legacy tab title; prayer_screen.dart uses 'prayer.fard_guide' |
| 65 | `prayer.times_header` | "Prayer times" | Legacy header; prayer_screen.dart uses 'prayer.times_title' |
| 66 | `prayer.wudu` | "Wudu Guide" | Legacy guide key; wudu_guide_page.dart uses 'prayer.wudu_steps_title' |
| 67 | `qaida.activity.boss_challenge_prompt` | "Boss Challenge! Find the target letter in the Quranic word:" | Unused prompt key; activities use curriculum step prompt keys |
| 68 | `qaida.activity.draw_trace_prompt` | "Trace the letter with your finger and remember the makhraj:" | Unused prompt key |
| 69 | `qaida.activity.explanation_boss_passed` | "MashaAllah! You have successfully mastered this lesson!" | Unused explanation key |
| 70 | `qaida.activity.explanation_correct` | "MashaAllah! Excellent work." | Unused explanation key |
| 71 | `qaida.activity.explanation_letter_recognized` | "Correct! You recognized the letter form perfectly." | Unused explanation key |
| 72 | `qaida.activity.explanation_pairs_matched` | "Great memory! Pairs matched successfully." | Unused explanation key |
| 73 | `qaida.activity.ghunnah_meter_prompt` | "Hold the nasal ghunnah meter for 2 counts:" | Unused prompt key |
| 74 | `qaida.activity.listen_and_tap` | "Listen to the pronunciation and tap the correct letter:" | Unused prompt key |
| 75 | `qaida.activity.madd_stretch_prompt` | "Hold and stretch the madd bar for the correct duration:" | Unused prompt key |
| 76 | `qaida.activity.match_letter_name` | "Match each letter with its name:" | Unused prompt key |
| 77 | `qaida.activity.memory_match_prompt` | "Flip the cards and find the matching letter and sound:" | Unused prompt key |
| 78 | `qaida.activity.odd_one_out_prompt` | "Which one is different? Find the letter outside this group:" | Unused prompt key |
| 79 | `qaida.activity.recognize_letter` | "Which of the following is the correct letter?" | Unused prompt key |
| 80 | `qaida.activity.shaddah_press_prompt` | "Press the doubled shaddah letter with two taps:" | Unused prompt key |
| 81 | `qaida.activity.spot_mistake_prompt` | "Spot the mistake! Which letter or mark does not fit?" | Unused prompt key |
| 82 | `qaida.activity.tilawat_listen_prompt` | "Listen to the beautiful recitation and select the correct word:" | Unused prompt key |
| 83 | `qaida.activity.which_rule_prompt` | "Which Tajweed rule applies to this letter?" | Unused prompt key |
| 84 | `qaida.audio_unavailable` | "Sound is unavailable on this device." | Legacy audio warning; audio_service uses 'audio.failed' |
| 85 | `qaida.check_answer` | "Check Answer" | Unused button key; qaida_activity_screen.dart uses 'qaida.activity.check' |
| 86 | `qaida.checkpoint_correct_expl` | "Correct! This is {{title}}." | Unused explanation key |
| 87 | `qaida.checkpoint_q_title` | "Checkpoint Question {{number}}: Which is the correct Arabic form of {{title}}?" | Unused exam question key |
| 88 | `qaida.correct` | "MashaAllah! Correct!" | Legacy feedback string; qaida_activity_screen.dart uses 'qaida.activity.feedback_correct' |
| 89 | `qaida.course.connected_letters` | "Connected Letters" | Legacy course name; qaida_next_course_screen.dart uses 'qaida.course.0.title' |
| 90 | `qaida.course.harakat` | "Vowels (Harakat)" | Legacy course name; qaida_next_course_screen.dart uses 'qaida.course.1.title' |
| 91 | `qaida.course.madd_ghunnah` | "Madd & Ghunnah" | Legacy course name; qaida_next_course_screen.dart uses 'qaida.course.2.title' |
| 92 | `qaida.course.tilawat` | "Ayah Reading" | Legacy course name; qaida_next_course_screen.dart uses 'qaida.course.3.title' |
| 93 | `qaida.final_correct_expl` | "MashaAllah! You gave the correct answer." | Unused exam explanation key |
| 94 | `qaida.final_exam_desc` | "Comprehensive questions from all lessons in the track. Passing unlocks the next track." | Unused exam desc key |
| 95 | `qaida.final_exam_subtitle` | "Track {{number}} Final Assessment" | Unused exam subtitle key |
| 96 | `qaida.final_exam_title` | "{{title}} - Final Exam" | Unused exam title key |
| 97 | `qaida.final_q_title` | "Final Question {{number}}: Which is the correct rule/form of {{title}}?" | Unused exam question key |
| 98 | `qaida.in_progress` | "In Progress" | Unused status badge key |
| 99 | `qaida.incorrect` | "Try again — you can do it!" | Legacy feedback string; qaida_activity_screen.dart uses 'qaida.activity.feedback_incorrect' |
| 100 | `qaida.lesson.step_counter` | "{{current}} / {{total}}" | Unused counter key; qaida_lesson_screen.dart uses custom format |
| 101 | `qaida.parent_confirm` | "Yes, Correct" | Legacy parent portal button |
| 102 | `qaida.parent_help` | "Ask a grown-up for help" | Legacy parent dialog key |
| 103 | `qaida.parent_retry` | "Retry" | Legacy parent retry button |
| 104 | `qaida.parent_verify_prompt` | "Did the child pronounce "{{letter}}" correctly?" | Legacy parent verification prompt |
| 105 | `qaida.quit_dialog_body` | "Your progress (Step {{stepNumber}}) will be saved. You can resume anytime." | Legacy quit dialog; qaida_lesson_screen.dart uses 'qaida.lesson.exit_confirm' |
| 106 | `qaida.quit_dialog_exit` | "Exit" | Legacy quit dialog; qaida_lesson_screen.dart uses 'qaida.lesson.exit' |
| 107 | `qaida.quit_dialog_stay` | "Keep Reading" | Legacy quit dialog; qaida_lesson_screen.dart uses 'qaida.lesson.keep_learning' |
| 108 | `qaida.quit_dialog_title` | "Exit lesson?" | Legacy quit dialog; qaida_lesson_screen.dart uses 'qaida.lesson.exit_title' |
| 109 | `qaida.step.10.act.1.explanation` | "MashaAllah! Correctly solved for Step 10!" | Unused explanation key; step 10 uses lesson description |
| 110 | `qaida.step.11.act.1.explanation` | "MashaAllah! Correctly solved for Step 11!" | Unused explanation key; step 11 uses lesson description |
| 111 | `qaida.step.12.act.1.explanation` | "MashaAllah! Correctly solved for Step 12!" | Unused explanation key; step 12 uses lesson description |
| 112 | `qaida.step.13.act.1.explanation` | "MashaAllah! Correctly solved for Step 13!" | Unused explanation key; step 13 uses lesson description |
| 113 | `qaida.step.14.act.1.explanation` | "MashaAllah! Correctly solved for Step 14!" | Unused explanation key; step 14 uses lesson description |
| 114 | `qaida.step.15.act.1.explanation` | "MashaAllah! Correctly solved for Step 15!" | Unused explanation key; step 15 uses lesson description |
| 115 | `qaida.step.16.act.1.explanation` | "MashaAllah! Correctly solved for Step 16!" | Unused explanation key; step 16 uses lesson description |
| 116 | `qaida.step.17.act.1.explanation` | "MashaAllah! Correctly solved for Step 17!" | Unused explanation key; step 17 uses lesson description |
| 117 | `qaida.step.3.act.2.explanation` | "MashaAllah! Correctly solved for Step 3!" | Unused explanation key; step 3 act 2 uses lesson description |
| 118 | `qaida.step.6.act.1.explanation` | "MashaAllah! Correctly solved for Step 6!" | Unused explanation key; step 6 uses lesson description |
| 119 | `qaida.step.7.act.1.explanation` | "MashaAllah! Correctly solved for Step 7!" | Unused explanation key; step 7 uses lesson description |
| 120 | `qaida.step.8.act.1.explanation` | "MashaAllah! Correctly solved for Step 8!" | Unused explanation key; step 8 uses lesson description |
| 121 | `qaida.step.9.act.1.explanation` | "MashaAllah! Correctly solved for Step 9!" | Unused explanation key; step 9 uses lesson description |
| 122 | `qaida.subtitle` | "Master Arabic alphabet & correct Makhraj" | Legacy subtitle; module_registry.dart uses 'nav.qaida_subtitle' |
| 123 | `qaida.track.1.subtitle` | "28 Arabic letters recognition & pronunciation" | Unused track subtitle; qaida_curriculum_data.dart links subtitle to 'qaida.track.1.title' |
| 124 | `qaida.track.2.subtitle` | "Forms in initial, medial, and final positions" | Unused track subtitle |
| 125 | `qaida.track.3.subtitle` | "Fatha, Kasra, and Damma" | Unused track subtitle |
| 126 | `qaida.track.4.subtitle` | "Double Fatha, Double Kasra, Double Damma" | Unused track subtitle |
| 127 | `qaida.track.5.subtitle` | "Prolonged vowels and soft letters" | Unused track subtitle |
| 128 | `qaida.track.6.subtitle` | "Jazm and double emphasis rules" | Unused track subtitle |
| 129 | `qaida.track.7.subtitle` | "Noon Sakin, Meem Sakin, and Madd" | Unused track subtitle |
| 130 | `qaida.track.8.subtitle` | "Surah Al-Fatiha and short Surahs" | Unused track subtitle |
| 131 | `quran.ayah` | "Ayah" | Unused label; quran_screen.dart uses 'quran.verse' |
| 132 | `quran.pause` | "Pause" | Legacy audio button; quran_screen.dart uses 'audio.pause' |
| 133 | `quran.reciter` | "Reciter" | Legacy selector label; quran_screen.dart uses 'quran.select_reciter' |
| 134 | `quran.wait_load_surah` | "Reading will begin once the Surah list loads." | Unused loading status string |
| 135 | `seerah.moral` | "Moral Lesson" | Legacy section label; seerah_screen.dart uses 'seerah.lesson_learned' |
| 136 | `seerah.read_story` | "Read Story" | Legacy card button; seerah_screen.dart uses 'seerah.read_button' |
| 137 | `seerah.timeline` | "Timeline" | Unused tab label |
| 138 | `seerah.title` | "Prophet Stories" | Legacy title; module_registry.dart uses 'nav.seerah' |
| 139 | `settings.notifications` | "Notification" | Legacy section header; settings_screen.dart uses 'settings.notifications_title' |
| 140 | `settings.payment_placeholder` | "Subscription & payments coming soon." | Legacy payment placeholder dialog |
| 141 | `settings.privacy_body` | "Little Muslim protects children's privacy. All progress is stored locally on this device." | Legacy privacy dialog; settings_screen.dart uses 'settings.privacy_policy_content' |
| 142 | `settings.reset_data` | "Reset All Progress" | Legacy button label; settings_screen.dart uses 'settings.reset_progress' |
| 143 | `settings.reset_warning` | "Are you sure? This will delete all XP, streaks, and progress." | Legacy dialog text; settings_screen.dart uses 'settings.reset_dialog_body' |
| 144 | `settings.sound_effects` | "Sound Effects" | Legacy switch label; settings_screen.dart uses 'settings.sound_enabled' |
| 145 | `validation.email_invalid` | "Please enter a valid email address" | Legacy validator; login_screen.dart handles validation via snackbar |
| 146 | `validation.name_required` | "Please enter your name" | Legacy validator; onboarding handles name validation inline |
| 147 | `validation.password_min` | "Password must be at least 6 characters" | Legacy validator |
| 148 | `validation.required` | "This field is required" | Unused form validator string |

## 3. Evidence of Zero References in Active Dart Code

### A. `auth.*` Keys
```bash
$ grep -rn "auth\." lib/ --exclude="static_translations.dart"
# Matches only comments with the word 'authentic':
# lib/data/qaida_curriculum_data.dart:1251:  // Uses 10 distinct authentic practice words...
# lib/services/alert_sound_service.dart:9:/// Service to handle authentic audio alerts...
# lib/services/alert_sound_service.dart:37:  /// Play the authentic Adhan audio.
# lib/services/alert_sound_service.dart:57:  /// Play the authentic Auzubillah...
```

### Why `login_screen.dart` does not use `auth.*` keys:
`LoginScreen` ([lib/screens/profile/login_screen.dart](file:///Users/mdmansur/Desktop/apk/little_muslim/lib/screens/profile/login_screen.dart)) uses the dedicated `login.*` translation namespace:
- `login.new_account`
- `login.welcome_back`
- `login.subtitle`
- `login.create_account_title`
- `login.parent_email_hint`
- `login.parent_email_label`
- `login.password_label`
- `login.login_button`
- `login.create_account_button`
- `login.service_unavailable_snack`

### B. `onboarding.welcome_title`
```bash
$ grep -rn "onboarding\.welcome_title" lib/
# Exit code 1 (0 matches)
```
Replaced by `onboarding.welcome_heading` in [lib/screens/onboarding/welcome_page.dart](file:///Users/mdmansur/Desktop/apk/little_muslim/lib/screens/onboarding/welcome_page.dart).

### C. `settings.reset_data`
```bash
$ grep -rn "settings\.reset_data" lib/
# Exit code 1 (0 matches)
```
Replaced by `settings.reset_progress` in [lib/screens/settings/settings_screen.dart](file:///Users/mdmansur/Desktop/apk/little_muslim/lib/screens/settings/settings_screen.dart).

### D. `validation.required`
```bash
$ grep -rn "validation\.required" lib/
# Exit code 1 (0 matches)
```
No form validation helper in `lib/` calls `validation.required`.

### E. `missions.streak_days.*`
```bash
$ grep -rn "missions\.streak_days" lib/ --exclude="static_translations.dart"
# Matches only documentation comment in lib/l10n/app_localizations.dart:69
# /// Pluralization translation shortcut (e.g. `plural('missions.streak_days', count)`).
```
Streak days in active UI are formatted via `profile.streak_xp` in [lib/screens/profile/profile_screen.dart](file:///Users/mdmansur/Desktop/apk/little_muslim/lib/screens/profile/profile_screen.dart).

### F. `qaida.track.*.subtitle`
```bash
$ grep -rn "qaida\.track\..*\.subtitle" lib/
# Exit code 1 (0 matches)
```
[lib/data/qaida_curriculum_data.dart](file:///Users/mdmansur/Desktop/apk/little_muslim/lib/data/qaida_curriculum_data.dart) lines 52, 260, 423, 579, 770, 961, 1025, 1133 use `subtitle: 'qaida.track.X.title'` directly.
