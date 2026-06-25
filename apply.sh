#!/usr/bin/env bash
set -euo pipefail

if ! command -v nix &>/dev/null; then
  curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
fi

# Host identity lives in the untracked .envrc.local (export HOST=...), so the
# machine name never lands in this public repo.
# shellcheck disable=SC1091
[ -f .envrc.local ] && source .envrc.local
FLAKE=".#${HOST:?set HOST in .envrc.local, e.g. export HOST=darwin}"

if [ ! -d /run/current-system ]; then
  sudo -H "$(which nix)" --extra-experimental-features 'nix-command flakes' run github:LnL7/nix-darwin -- switch --flake "$FLAKE"
else
  sudo -H /run/current-system/sw/bin/darwin-rebuild switch --flake "$FLAKE"
fi
