# tm

A deliberately small macOS terminal. It runs your login shell and follows the macOS Light/Dark appearance automatically.

## Run during development

```sh
swift run tm
```

Open `Package.swift` in Xcode if you prefer Xcode's Run button.

## Build a macOS app

```sh
chmod +x Scripts/build-app.sh
Scripts/build-app.sh
open dist/tm.app
```

The resulting app is ad-hoc signed and intended for personal use. If macOS blocks the first launch, Control-click the app and choose Open.

## Automatic theme

tm defaults to **Auto**, which follows the current macOS appearance without private APIs or extra permissions. In **System Settings → Appearance**, select **Auto**. macOS will then change appearance through the day and tm updates its terminal palette immediately.

You can override this from **Theme → Light/Dark**, or return to **Theme → Auto**.

Night Shift changes display color temperature and does not expose a supported public API for third-party apps to read its live state. Following macOS appearance is the stable equivalent; configure both macOS Appearance and Night Shift for the same day/night behavior.

## Scope

- Local login shell (`$SHELL`, with `/bin/zsh` fallback)
- ANSI/256/true color, Unicode, selection, copy/paste, links, and terminal resizing via SwiftTerm
- One preference: Auto, Light, or Dark theme
- No accounts, telemetry, cloud sync, or AI features

SwiftTerm is included through Swift Package Manager and is licensed under the MIT License.
