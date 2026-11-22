# Concerta

A tiny, menu-bar-only macOS app for toggling sleep prevention.

- **Keep Mac awake** prevents idle system sleep (`caffeinate -i`).
- **Keep display awake** prevents display idle sleep (`caffeinate -d`).
- The two options can be toggled independently or together.
- The release builds support both Apple silicon and Intel Macs.
- The custom pill icon is hollow when inactive and partly filled when either
  option is on; it fills further when both are enabled.
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

To publish a release, update `CFBundleShortVersionString` in
`Resources/Info.plist` and push a matching `vMAJOR.MINOR.PATCH` tag. GitHub
Actions builds architecture-specific app archives and publishes them as a
GitHub Release.
