# LittleMuslim 🌙

A fun, Duolingo-inspired Islamic learning app for kids aged **6–14**.

Learn Quran, Qaida, Salah, Masnun Duas, and the Seerah of Prophet Muhammad ﷰ through games, stories, and beautiful design.

---

## Features (Planned)

- **Onboarding** – Welcome, Name, Age, Language selection
- **Qaida Learning** – Duolingo-style lessons with XP, streaks, badges (games only for letters & rules)
- **Colorful Quran Reader** – Page-by-page eBook style (swipe to change pages), no games during tilawah
- **Daily Prayer Times** + step-by-step Salah learning
- **Masnun Duas** categorized
- **Seerah Stories** for children
- **Islamic fun stories** from Hadith & history (shown during Quran reading mode)
- Fully responsive for **Phone + Tablet / iPad**
- Islamic Middle-East inspired UI (teal-green + gold + cream)

---

## Getting Started

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

### Project Structure

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart          # Colors, typography, Material 3 theme
├── utils/
│   └── app_state.dart          # Global state (Provider)
├── screens/
│   └── onboarding/
│       ├── onboarding_screen.dart
│       ├── welcome_page.dart
│       ├── name_age_page.dart
│       ├── language_page.dart
│       └── ready_page.dart
├── widgets/                    # Shared widgets (coming)
└── models/                     # Data models (coming)
```

---

## Current Status

✅ Onboarding flow (4 screens) – Welcome → Name & Age → Language → Ready
🔄 Next: Home Screen + Bottom Navigation + Qaida module

---

## Design Notes

- Primary: `#0D7377` (Deep Teal Green)
- Accent: `#D4A017` (Gold)
- Background: `#F8F1E3` (Cream)
- Fully responsive using `MediaQuery` + `shortestSide >= 600` for tablet detection

---

Made with ❤️ for the next generation of young Muslims.
