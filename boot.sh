#!/usr/bin/env bash
set -euo pipefail

repo_url="${NOTARCHY_REPO_URL:-https://github.com/notliad/notarchy.git}"
repo_dir="${NOTARCHY_REPO_DIR:-/tmp/notarchy}"

pacman -Sy --needed --noconfirm git
rm -rf "$repo_dir"
git clone "$repo_url" "$repo_dir"
exec "$repo_dir/install/notarchy-install" "$@"

