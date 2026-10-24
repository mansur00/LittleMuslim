# Data & Model i18n Audit Report

Generated: 2026-10-23T15:43:11.535Z

This audit scans `lib/data/`, `lib/screens/qaida/`, and `lib/models/` for any non-pure-Arabic string literals:
- Bangla script [\u0980-\u09FF]
- Devanagari script [\u0900-\u097F]
- English sentence / description strings & transliterations

## Summary of Violations

| Category | Count |
|---|---|
| English Prose / Term | 118 |
| **Total Violations** | **118** |

## Detailed Findings by File

| File:Line | Issue Type | Offending Literal |
|---|---|---|
| `lib/data/nurani_qaida_data.dart:99` | English Prose / Term | `Alif` |
| `lib/data/nurani_qaida_data.dart:105` | English Prose / Term | `Baa` |
| `lib/data/nurani_qaida_data.dart:111` | English Prose / Term | `Taa` |
| `lib/data/nurani_qaida_data.dart:117` | English Prose / Term | `Thaa` |
| `lib/data/nurani_qaida_data.dart:123` | English Prose / Term | `Jeem` |
| `lib/data/nurani_qaida_data.dart:129` | English Prose / Term | `Haa` |
| `lib/data/nurani_qaida_data.dart:135` | English Prose / Term | `Khaa` |
| `lib/data/nurani_qaida_data.dart:141` | English Prose / Term | `Daal` |
| `lib/data/nurani_qaida_data.dart:147` | English Prose / Term | `Dhaal` |
| `lib/data/nurani_qaida_data.dart:153` | English Prose / Term | `Raa` |
| `lib/data/nurani_qaida_data.dart:159` | English Prose / Term | `Zaay` |
| `lib/data/nurani_qaida_data.dart:165` | English Prose / Term | `Seen` |
| `lib/data/nurani_qaida_data.dart:171` | English Prose / Term | `Sheen` |
| `lib/data/nurani_qaida_data.dart:177` | English Prose / Term | `Saad` |
| `lib/data/nurani_qaida_data.dart:183` | English Prose / Term | `Daad` |
| `lib/data/nurani_qaida_data.dart:189` | English Prose / Term | `Taa` |
| `lib/data/nurani_qaida_data.dart:195` | English Prose / Term | `Zaa` |
| `lib/data/nurani_qaida_data.dart:201` | English Prose / Term | `Ayn` |
| `lib/data/nurani_qaida_data.dart:207` | English Prose / Term | `Ghayn` |
| `lib/data/nurani_qaida_data.dart:213` | English Prose / Term | `Faa` |
| `lib/data/nurani_qaida_data.dart:219` | English Prose / Term | `Qaaf` |
| `lib/data/nurani_qaida_data.dart:225` | English Prose / Term | `Kaaf` |
| `lib/data/nurani_qaida_data.dart:231` | English Prose / Term | `Laam` |
| `lib/data/nurani_qaida_data.dart:237` | English Prose / Term | `Meem` |
| `lib/data/nurani_qaida_data.dart:243` | English Prose / Term | `Noon` |
| `lib/data/nurani_qaida_data.dart:249` | English Prose / Term | `Waaw` |
| `lib/data/nurani_qaida_data.dart:255` | English Prose / Term | `Haa` |
| `lib/data/nurani_qaida_data.dart:261` | English Prose / Term | `Yaa` |
| `lib/data/nurani_qaida_data.dart:396` | English Prose / Term | `Mufradat` |
| `lib/data/nurani_qaida_data.dart:400` | English Prose / Term | `Phase 1: Foundation` |
| `lib/data/nurani_qaida_data.dart:516` | English Prose / Term | `$init \| $med \| $fin` |
| `lib/data/nurani_qaida_data.dart:529` | English Prose / Term | `Murakkabat` |
| `lib/data/nurani_qaida_data.dart:533` | English Prose / Term | `Phase 1: Foundation` |
| `lib/data/nurani_qaida_data.dart:656` | English Prose / Term | `Harakat` |
| `lib/data/nurani_qaida_data.dart:660` | English Prose / Term | `Phase 2: Harakat` |
| `lib/data/nurani_qaida_data.dart:790` | English Prose / Term | `Tanween` |
| `lib/data/nurani_qaida_data.dart:794` | English Prose / Term | `Phase 2: Harakat` |
| `lib/data/nurani_qaida_data.dart:917` | English Prose / Term | `Khari Harakat` |
| `lib/data/nurani_qaida_data.dart:921` | English Prose / Term | `Phase 2: Harakat` |
| `lib/data/nurani_qaida_data.dart:1043` | English Prose / Term | `Layyin` |
| `lib/data/nurani_qaida_data.dart:1047` | English Prose / Term | `Phase 3: Sukoon-Shaddah` |
| `lib/data/nurani_qaida_data.dart:1173` | English Prose / Term | `Sukoon` |
| `lib/data/nurani_qaida_data.dart:1177` | English Prose / Term | `Phase 3: Sukoon-Shaddah` |
| `lib/data/nurani_qaida_data.dart:1300` | English Prose / Term | `Shaddah` |
| `lib/data/nurani_qaida_data.dart:1304` | English Prose / Term | `Phase 3: Sukoon-Shaddah` |
| `lib/data/nurani_qaida_data.dart:1430` | English Prose / Term | `Noon Sakin` |
| `lib/data/nurani_qaida_data.dart:1434` | English Prose / Term | `Phase 4: Tajweed Core` |
| `lib/data/nurani_qaida_data.dart:1563` | English Prose / Term | `Meem Sakin` |
| `lib/data/nurani_qaida_data.dart:1567` | English Prose / Term | `Phase 4: Tajweed Core` |
| `lib/data/nurani_qaida_data.dart:1688` | English Prose / Term | `Ghunnah` |
| `lib/data/nurani_qaida_data.dart:1692` | English Prose / Term | `Phase 4: Tajweed Core` |
| `lib/data/nurani_qaida_data.dart:1816` | English Prose / Term | `Madd` |
| `lib/data/nurani_qaida_data.dart:1820` | English Prose / Term | `Phase 4: Tajweed Core` |
| `lib/data/nurani_qaida_data.dart:1952` | English Prose / Term | `Lam Rules` |
| `lib/data/nurani_qaida_data.dart:1956` | English Prose / Term | `Phase 5: Advanced` |
| `lib/data/nurani_qaida_data.dart:2085` | English Prose / Term | `Ra and Lam` |
| `lib/data/nurani_qaida_data.dart:2089` | English Prose / Term | `Phase 5: Advanced` |
| `lib/data/nurani_qaida_data.dart:2215` | English Prose / Term | `Muqattaat & Qalqalah` |
| `lib/data/nurani_qaida_data.dart:2219` | English Prose / Term | `Phase 5: Advanced` |
| `lib/data/nurani_qaida_data.dart:2343` | English Prose / Term | `Waqf` |
| `lib/data/nurani_qaida_data.dart:2347` | English Prose / Term | `Phase 6: Reading` |
| `lib/data/nurani_qaida_data.dart:2482` | English Prose / Term | `Tilawat` |
| `lib/data/nurani_qaida_data.dart:2486` | English Prose / Term | `Phase 6: Reading` |
| `lib/data/qaida_curriculum_data.dart:280` | English Prose / Term | `$init  $med  $fin` |
| `lib/data/qaida_curriculum_data.dart:351` | English Prose / Term | `$init  $med  $fin` |
| `lib/data/qaida_curriculum_data.dart:406` | English Prose / Term | `$init $med $fin` |
| `lib/screens/qaida/qaida_activity_screen.dart:129` | English Prose / Term | `Test` |
| `lib/screens/qaida/qaida_activity_screen.dart:795` | English Prose / Term | `${_currentActivityIndex + 1}/${widget.lesson.activities.length}` |
| `lib/screens/qaida/qaida_activity_screen.dart:3350` | English Prose / Term | `Test` |
| `lib/screens/qaida/qaida_activity_screen.dart:4458` | English Prose / Term | `$rawTarget  [ ${selectedWord ?? ` |
| `lib/screens/qaida/qaida_activity_screen.dart:4996` | English Prose / Term | `+$xpEarned XP` |
| `lib/screens/qaida/qaida_activity_screen.dart:5138` | English Prose / Term | `$combo Combo!` |
| `lib/screens/qaida/qaida_lesson_screen.dart:138` | English Prose / Term | `STT error: $err` |
| `lib/screens/qaida/qaida_lesson_screen.dart:142` | English Prose / Term | `STT status: $status` |
| `lib/screens/qaida/qaida_lesson_screen.dart:310` | English Prose / Term | `${_step + 1} / ${stepNames.length}` |
| `lib/screens/qaida/qaida_lesson_screen.dart:1003` | English Prose / Term | `${context.uiText(name)} · $arabicName` |
| `lib/screens/qaida/qaida_letters.dart:25` | English Prose / Term | `Alif` |
| `lib/screens/qaida/qaida_letters.dart:26` | English Prose / Term | `Baa` |
| `lib/screens/qaida/qaida_letters.dart:27` | English Prose / Term | `Taa` |
| `lib/screens/qaida/qaida_letters.dart:28` | English Prose / Term | `Thaa` |
| `lib/screens/qaida/qaida_letters.dart:29` | English Prose / Term | `Jeem` |
| `lib/screens/qaida/qaida_letters.dart:30` | English Prose / Term | `Haa` |
| `lib/screens/qaida/qaida_letters.dart:31` | English Prose / Term | `Khaa` |
| `lib/screens/qaida/qaida_letters.dart:32` | English Prose / Term | `Daal` |
| `lib/screens/qaida/qaida_letters.dart:33` | English Prose / Term | `Dhaal` |
| `lib/screens/qaida/qaida_letters.dart:34` | English Prose / Term | `Raa` |
| `lib/screens/qaida/qaida_letters.dart:35` | English Prose / Term | `Zaay` |
| `lib/screens/qaida/qaida_letters.dart:36` | English Prose / Term | `Seen` |
| `lib/screens/qaida/qaida_letters.dart:37` | English Prose / Term | `Sheen` |
| `lib/screens/qaida/qaida_letters.dart:38` | English Prose / Term | `Saad` |
| `lib/screens/qaida/qaida_letters.dart:39` | English Prose / Term | `Daad` |
| `lib/screens/qaida/qaida_letters.dart:40` | English Prose / Term | `Toa` |
| `lib/screens/qaida/qaida_letters.dart:41` | English Prose / Term | `Zoa` |
| `lib/screens/qaida/qaida_letters.dart:42` | English Prose / Term | `Ayn` |
| `lib/screens/qaida/qaida_letters.dart:43` | English Prose / Term | `Ghayn` |
| `lib/screens/qaida/qaida_letters.dart:44` | English Prose / Term | `Faa` |
| `lib/screens/qaida/qaida_letters.dart:45` | English Prose / Term | `Qaaf` |
| `lib/screens/qaida/qaida_letters.dart:46` | English Prose / Term | `Kaaf` |
| `lib/screens/qaida/qaida_letters.dart:47` | English Prose / Term | `Laam` |
| `lib/screens/qaida/qaida_letters.dart:48` | English Prose / Term | `Meem` |
| `lib/screens/qaida/qaida_letters.dart:49` | English Prose / Term | `Noon` |
| `lib/screens/qaida/qaida_letters.dart:50` | English Prose / Term | `Haa` |
| `lib/screens/qaida/qaida_letters.dart:51` | English Prose / Term | `Waaw` |
| `lib/screens/qaida/qaida_letters.dart:52` | English Prose / Term | `Yaa` |
| `lib/screens/qaida/qaida_report_screen.dart:620` | English Prose / Term | `${(skill.accuracy * 100).toInt()}` |
| `lib/screens/qaida/qaida_track_lessons_screen.dart:44` | English Prose / Term | `Test` |
| `lib/screens/qaida/qaida_track_lessons_screen.dart:875` | English Prose / Term | `Checkpoint Exam $blockNumber` |
| `lib/screens/qaida/qaida_track_lessons_screen.dart:876` | English Prose / Term | `Assessment of lessons ${startIdx + 1} to $endIdx` |
| `lib/screens/qaida/qaida_track_lessons_screen.dart:879` | English Prose / Term | `Test your knowledge from the previous 5 lessons. Passing score: 80/100.` |
| `lib/screens/qaida/qaida_track_lessons_screen.dart:908` | English Prose / Term | `Checkpoint Question ${qIdx + 1}: Which is the correct Arabic form of ${refLesson.title}?` |
| `lib/screens/qaida/qaida_track_lessons_screen.dart:912` | English Prose / Term | `Correct! This is ${refLesson.title}.` |
| `lib/screens/qaida/qaida_track_lessons_screen.dart:955` | English Prose / Term | `Final Question ${qIdx + 1}: Which is the correct rule/form of ${refLesson.title}?` |
| `lib/screens/qaida/qaida_track_lessons_screen.dart:959` | English Prose / Term | `MashaAllah! You gave the correct answer.` |
| `lib/models/qaida/qaida_models.dart:291` | English Prose / Term | `Standard lessons must have at least 7 activities` |
| `lib/models/qaida/qaida_models.dart:394` | English Prose / Term | `Olive Tree` |
| `lib/models/qaida/qaida_models.dart:394` | English Prose / Term | `Date Palm` |
| `lib/models/qaida/qaida_models.dart:394` | English Prose / Term | `Jasmine Flower` |
| `lib/models/qaida/qaida_models.dart:394` | English Prose / Term | `Golden Lantern` |
