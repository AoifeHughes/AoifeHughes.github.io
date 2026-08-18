#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUBSITE_SRC="$ROOT_DIR/submodules/LLM-password-challenge/LLM-password-challenge"
SUBSITE_DEST="$ROOT_DIR/static/LLM-password-challenge"

if [ ! -d "$SUBSITE_SRC" ]; then
  echo "LLM-password-challenge submodule not found at $SUBSITE_SRC. Run 'git submodule update --init --recursive'." >&2
  exit 1
fi

cd "$SUBSITE_SRC"
npm ci
npm run build

rm -rf "$SUBSITE_DEST"
mkdir -p "$SUBSITE_DEST"
cp -r "$SUBSITE_SRC/dist/." "$SUBSITE_DEST/"

echo "Built LLM Password Challenge into $SUBSITE_DEST"
