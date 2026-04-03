# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter interval timer app for iOS and Android. Users configure training/pause durations and sets, then run timed workouts with audio cues. Supports saving workouts, dark mode, and English/German localization.

## Common Commands

```bash
flutter run                    # Run the app (debug mode)
flutter build ios              # Build for iOS
flutter build apk              # Build for Android
flutter analyze                # Run static analysis (uses flutter_lints)
flutter gen-l10n               # Regenerate localization files from ARB files
dart run build_runner build    # Regenerate Hive adapters (workout.g.dart)
```

## Architecture

### Data Layer
- **Hive** for local persistence — two boxes: `"workouts"` (stores `Workout` objects) and `"settings"` (dark mode, language, sound preference)
- `lib/workout.dart` — Hive model with `workout.g.dart` generated adapter. After modifying `Workout` fields, regenerate with build_runner
- Settings are accessed directly via `Hive.box("settings").get(key)` throughout the codebase (no abstraction layer)

### Navigation & Pages
Three-tab bottom nav (`Home` widget): **Workouts** (index 0), **Jump In** (index 1), **Profile** (index 2).

Workout execution flow: **JumpIn** → **InitialisationScreen** → **Preparation** (9s countdown) → **Run** (active timer) → **Congrats**

### Audio System
The audio system is the most complex part of the codebase:
- `lib/pages/run/audio_handler.dart` — Uses Dart I/O byte concatenation to combine silent duration MP3s + countdown sounds into `run.mp3` and `pause.mp3` at runtime
- Duration is built from pre-made silence clips (30min, 10min, 5min, 1min, 30sec, 10sec, 5sec, 1sec) combined to match the exact training/pause time
- **just_audio** with `ConcatenatingAudioSource` plays alternating training/pause segments; the player's `currentIndex` determines which segment is active
- `just_audio_background` enables background playback and lock screen controls
- Audio session configured to duck other audio (`mixWithOthers` + `gainTransientMayDuck`)

### Theming
- `lib/const.dart` — Full light/dark color palette (`lightNeutral*`/`darkNeutral*` plus success/warning/error scales) and text style functions that take `context` to auto-switch on dark mode
- Dark mode toggled via `MyApp.of(context).changeTheme()`, persisted in Hive, switches live via `setState()` on root widget

### Localization
- ARB files in `lib/l10n/` (English template: `app_en.arb`, German: `app_de.arb`)
- Auto-generated via `flutter gen-l10n` (configured in `l10n.yaml`, `generate: true` in pubspec)
- Accessed as `AppLocalizations.of(context)!.key_name`

### iOS-Specific
- `ios/Lockscreen/` — iOS Live Activity / Lock Screen widget (Swift)
- `ios/Runner/LockscreenController/` — Data model bridging Flutter and native lock screen
