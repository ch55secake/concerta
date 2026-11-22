# Concerta

A tiny, menu-bar-only macOS app for toggling sleep prevention.

- **Keep Mac awake** prevents idle system sleep (`caffeinate -i`).
- **Keep display awake** prevents display idle sleep (`caffeinate -d`).
- The two options can be toggled independently or together.
- The release builds support both Apple silicon and Intel Macs.
- The custom pill icon is hollow when inactive and half-filled whenever either
  or both options are enabled.
- The menu bar shows compact system uptime beside the icon.
- Concerta starts with both options off and stops `caffeinate` when you quit.

The app has no Dock icon. It requires macOS 13 or later.

## Install with Homebrew

```sh
brew install --cask ch55secake/tap/concerta
```

Concerta is not notarized by Apple. On first launch, macOS may require allowing
it from **System Settings → Privacy & Security → Open Anyway**.

## Build

```sh
./scripts/build.sh
```

This creates `build/Concerta.app`.

## Install and launch

```sh
./scripts/install.sh
```

This installs the app in `~/Applications/Concerta.app` and opens it.

## Releases

To publish a release, update `CFBundleShortVersionString` and `CFBundleVersion`
in `Resources/Info.plist` and merge the change to `main`. GitHub Actions
automatically creates the matching `vMAJOR.MINOR.PATCH` tag, builds
architecture-specific app archives, and publishes the GitHub Release.
