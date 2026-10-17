# LittleMuslim 🌙

LittleMuslim is a Flutter learning app for children, with a Bengali-first interface and a Duolingo-inspired learning path.

## Implemented features

- Four-step onboarding for a learner's name, age, and preferred language.
- A home screen linking to Qaida, Quran, prayer learning, duas, Seerah, basic Islamic learning, achievements, and daily missions.
- Interactive Qaida lessons for the 28 Arabic letters, plus lessons on joined letters and reading rules. Completed lessons award XP once and contribute to local progress, streaks, badges, and daily mission status.
- A Quran surah list and reading screen with Arabic text, Bengali translation, tajweed coloring, adjustable text size, local ayah bookmarks, last-read position, and recitation audio controls.
- Guided prayer steps and a small categorized collection of duas with locally saved favorites.
- Child-friendly Seerah stories with references and locally saved completion progress, plus basic Islamic learning chapters with resumable activity and saved quiz results.
- Student-facing live-class schedule and detail screens with status-aware joining through safe HTTPS meeting links.
- Qaida lesson summaries show whether XP was earned or already collected; exercises can be retried before continuing.
- Responsive layouts intended for phones and tablets.
- Local storage of onboarding details, settings, XP, completed lessons, in-progress Qaida steps and basic-learning activity, quiz results, Dua favorites, Seerah story completion, lesson activity, opened reward chests, Quran bookmarks, and last-read position using `shared_preferences`.

## Known limitations

- Quran surah text, translations, tajweed, and recitation audio require an internet connection and external Quran services; Quran text is not cached for offline reading.
- Prayer times use the [AlAdhan Prayer Times API](https://aladhan.com/prayer-times-api) for the selected date and location. The screen calculates Fajr, Dhuhr, Asr, Maghrib, and Isha; Sunrise is shown separately as a reference time, not a prayer. Students can enter a city and country without GPS, or explicitly choose device location. Device location is requested only after an explanation and button tap. The selected location, AlAdhan calculation method (supported standard method IDs 0–5 and 7–23), and Standard/Shafi or Hanafi Asr option are saved locally. Prayer times require internet access and are not cached for offline use. The API response supplies the location timezone; date navigation and automatic refresh use that timezone, including daylight-saving changes. Method conventions and local mosque timetables can differ, so families should follow their trusted local guidance. No prayer reminders are implemented.
- Dua audio is not available; the screen marks it unavailable and offers no audio playback control.
- The live-class screen currently uses an empty local repository because no real schedule or meeting-link source is connected. No sample classes are presented as real. A backend or trusted schedule provider must supply class details and links; attendance, class materials, and missed-class recovery are not available.
- The Quran story tab, live learning, account/login screens, and some device-dependent Arabic speech features are placeholders. There is no authentication or cloud sync.
- The student interface supports Bangla and English. Choose a language during onboarding or change it later in Settings; the choice is saved on this device and applies immediately. Arabic Quran text and quoted religious source text remain unchanged.
- Translations are maintained in `assets/l10n/app_bn.arb` and `assets/l10n/app_en.arb`. Add matching entries to both files with an `@key` description containing the source phrase used by the UI; then wrap new student-facing text in `LocalizedText` (or resolve it with `context.uiText` for tooltips and input labels). Check both languages on the affected screen and add/update a localization regression test.
- Localization is maintained in a custom Flutter `LocalizationsDelegate` that reads the ARB assets. Some longer explanatory or source/reference copy, proper names, and text supplied by remote Quran services remain in their original language; translations are not yet generated or checked automatically.
- The current static analysis run reports informational lint and deprecation notices; there are no analyzer errors.

## Getting started

### Prerequisites
- Flutter SDK 3.2+
- Android Studio / VS Code with Flutter extension
- Chrome (for web testing) or Android emulator / physical device

### Run the project

```bash
# Clone the repo
git clone https://github.com/mansur00/LittleMuslim.git
cd LittleMuslim

# Get packages
flutter pub get

# Run on connected device / emulator
flutter run
```

### Project structure

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart          # Colors, typography, Material theme
├── utils/
│   └── app_state.dart          # App state and local persistence
├── screens/
│   ├── onboarding/              # Welcome, learner details, language, ready
│   ├── home/                    # Home and module navigation
│   ├── qaida/                   # Letter path and lesson flows
│   ├── quran/                   # Surah list, reader, and Quran data source
│   └── ...                      # Prayer, duas, Seerah, profile, settings
└── widgets/                     # Shared UI components
```

## Checks

```bash
flutter pub get
flutter analyze
flutter test
```

Made with ❤️ for the next generation of young Muslims.
