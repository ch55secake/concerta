# Concerta

A tiny, menu-bar-only macOS app for toggling sleep prevention.

- **Keep Mac awake** prevents idle system sleep (`caffeinate -i`).
- **Keep display awake** prevents display idle sleep (`caffeinate -d`).
- The two options can be toggled independently or together.
- The custom pill-and-spark icon gets a sparkle whenever either option is on.
- Concerta starts with both options off and stops `caffeinate` when you quit.

The app has no Dock icon. It requires macOS 13 or later.

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
