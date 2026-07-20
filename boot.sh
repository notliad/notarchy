#!/usr/bin/env bash
set -euo pipefail

repo_url="${NOTARCHY_REPO_URL:-https://github.com/notliad/notarchy.git}"
repo_dir="${NOTARCHY_REPO_DIR:-/tmp/notarchy}"
repo_ref="${NOTARCHY_REF:-${NOTARCHY_BRANCH:-}}"

if [[ "${1:-}" == "--ref" || "${1:-}" == "--branch" ]]; then
  repo_ref="${2:-}"
  shift 2
fi

pacman -Syu --needed --noconfirm git gum rsync curl

case "$repo_dir" in
  /tmp/*) ;;
  *)
    printf 'Refusing to delete repo dir outside /tmp: %s\n' "$repo_dir" >&2
    exit 1
    ;;
esac

if mountpoint -q "$repo_dir"; then
  printf 'Refusing to delete mounted repo dir: %s\n' "$repo_dir" >&2
  exit 1
fi

rm -rf "$repo_dir"
git clone "$repo_url" "$repo_dir"
[[ -z "$repo_ref" ]] || git -C "$repo_dir" checkout --detach "$repo_ref"
exec "$repo_dir/install/notarchy-install" "$@"
