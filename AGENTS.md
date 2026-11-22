# Agent guidance

- Concerta is a macOS 13+ SwiftUI menu-bar app. Keep it menu-bar-only and preserve `LSUIElement` so it does not appear in the Dock.
- Keep “Keep Mac awake” (`caffeinate -i`) and “Keep display awake” (`caffeinate -d`) independent. Both should default to off, and the managed `caffeinate` process must stop when the app quits.
- Prefer native SwiftUI/AppKit APIs and avoid adding dependencies unless they materially help the app.
- Build and package with `./scripts/build.sh`. Validate the app bundle with `plutil -lint Resources/Info.plist` and `codesign --verify --deep --strict build/Concerta.app`.
- Release tags use `vMAJOR.MINOR.PATCH` and must match `CFBundleShortVersionString` in `Resources/Info.plist`; the release workflow builds Apple silicon and Intel archives.
- `./scripts/install.sh` installs and launches the app in `~/Applications`; only run it when installation or launch is requested.
- Keep generated `.build/` and `build/` outputs out of version control.
- Use concise Conventional Commit messages.
