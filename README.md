# LittleMuslim 🌙

LittleMuslim is a Flutter learning app for children, with a Bengali-first interface and a Duolingo-inspired learning path.

## Implemented features

- Four-step onboarding for a learner's name, age, and preferred language.
- A home screen linking to Qaida, Quran, prayer learning, duas, Seerah, basic Islamic learning, achievements, and daily missions.
- Interactive Qaida lessons for the 28 Arabic letters, plus lessons on joined letters and reading rules. Completed lessons award XP once and contribute to local progress, streaks, badges, and daily mission status.
- A Quran surah list and reading screen with Arabic text, Bengali translation, tajweed coloring, adjustable text size, local ayah bookmarks, last-read position, and recitation audio controls.
- Guided prayer steps and a small categorized collection of duas.
- Child-friendly Seerah stories with references, plus basic Islamic learning activities.
- Responsive layouts intended for phones and tablets.
- Local storage of onboarding details, settings, XP, completed lessons, in-progress Qaida steps, lesson activity, opened reward chests, Quran bookmarks, and last-read position using `shared_preferences`.

## Known limitations

- Quran surah text, translations, tajweed, and recitation audio require an internet connection and external Quran services; Quran text is not cached for offline reading.
- Prayer times are placeholders; location and calculation-method setup is not implemented.
- Dua favorites are kept only while the screen is open, and dua audio is not implemented.
- The Quran story tab, live learning, account/login screens, and some device-dependent Arabic speech features are placeholders. There is no authentication or cloud sync.
- The selected onboarding language is saved, but the interface is currently Bengali-first rather than fully localized.
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
