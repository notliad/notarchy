#!/usr/bin/env bash
set -euo pipefail

repo_url="${NOTARCHY_REPO_URL:-https://github.com/notliad/notarchy.git}"
repo_dir="${NOTARCHY_REPO_DIR:-/tmp/notarchy}"
repo_branch="${NOTARCHY_BRANCH:-}"

if [[ "${1:-}" == "--branch" ]]; then
  repo_branch="${2:-}"
  shift 2
fi

pacman -Sy --needed --noconfirm git gum rsync
rm -rf "$repo_dir"
if [[ -n "$repo_branch" ]]; then
  git clone --branch "$repo_branch" "$repo_url" "$repo_dir"
else
  git clone "$repo_url" "$repo_dir"
fi
exec "$repo_dir/install/notarchy-install" "$@"
