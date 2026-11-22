#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="$ROOT/build/Concerta.app"
CONTENTS="$APP/Contents"

swift build --package-path "$ROOT" --configuration release --product Concerta

mkdir -p "$CONTENTS/MacOS"
cp "$ROOT/.build/release/Concerta" "$CONTENTS/MacOS/Concerta"
cp "$ROOT/Resources/Info.plist" "$CONTENTS/Info.plist"

/usr/bin/codesign --force --deep --sign - "$APP"

echo "Built $APP"
