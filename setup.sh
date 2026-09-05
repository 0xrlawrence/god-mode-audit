#!/usr/bin/env bash
# God Mode Audit - assemble the full knowledge base locally.
#
# This repo ships ONLY original methodology. The domain knowledge bases it
# references are third-party and under their own licenses, so they are NOT
# redistributed here. This script clones them into domains/<pack>/upstream/
# on YOUR machine for personal research use. Review each upstream's LICENSE.
#
# Usage:  ./setup.sh          (clone/refresh all packs)
#         ./setup.sh --shallow (depth-1 clones, faster/smaller)
set -euo pipefail

DEPTH=""
[ "${1:-}" = "--shallow" ] && DEPTH="--depth 1"

clone() {  # clone <url> <dest>
  local url="$1" dest="$2"
  if [ -d "$dest/.git" ]; then
    echo "== updating $dest"; git -C "$dest" pull --ff-only || true
  else
    echo "== cloning $url -> $dest"; mkdir -p "$(dirname "$dest")"
    git clone $DEPTH "$url" "$dest"
  fi
}

ROOT="$(cd "$(dirname "$0")" && pwd)"

# pashov solidity-auditor (EVM 12-lens engine) -- smart-contracts pack
clone https://github.com/pashov/skills                       "$ROOT/domains/smart-contracts/upstream/pashov-skills"
# strix (autonomous pentest agent knowledge base)            -- strix pack
clone https://github.com/usestrix/strix                      "$ROOT/domains/strix/upstream/strix"
# skraft9 (web/appsec cheatsheets + recon)                   -- web-appsec pack
clone https://github.com/skraft9/vulnerability-research      "$ROOT/domains/web-appsec/upstream/skraft9"
# Trail of Bits skills (42 audit skills)                     -- trailofbits pack
clone https://github.com/trailofbits/skills                  "$ROOT/domains/trailofbits/upstream/tob-skills"

echo ""
echo "Done. Knowledge bases are under domains/*/upstream/ (git-ignored)."
echo "Each is governed by its own LICENSE. See ACKNOWLEDGEMENTS.md."
echo "Read GODAUDIT.md to start."
