#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="$ROOT/build/Concerta.app"
DESTINATION="$HOME/Applications/Concerta.app"

"$ROOT/scripts/build.sh"
mkdir -p "$HOME/Applications"
ditto "$APP" "$DESTINATION"
open "$DESTINATION"

echo "Installed and opened $DESTINATION"
