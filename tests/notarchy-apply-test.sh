#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/home/.config/ghostty"
printf 'old\n' > "$tmp/home/.config/ghostty/config"

NOTARCHY_CONFIG_ROOT="$repo_root/config" \
NOTARCHY_TARGET_CONFIG_ROOT="$tmp/home/.config" \
NOTARCHY_HOME_ROOT="$repo_root/home" \
NOTARCHY_TARGET_HOME="$tmp/home" \
NOTARCHY_BACKUP_TIMESTAMP=123 \
  "$repo_root/bin/notarchy-apply"

[[ -L "$tmp/home/.config/ghostty/config" ]]
[[ "$(readlink "$tmp/home/.config/ghostty/config")" == "$repo_root/config/ghostty/config" ]]
[[ "$(cat "$tmp/home/.config/ghostty/config.bak.123")" == old ]]
[[ -L "$tmp/home/.config/hypr/hyprland.conf" ]]
[[ -L "$tmp/home/.config/waybar/default-style.css" ]]
[[ -L "$tmp/home/.config/waybar/default-config.jsonc" ]]
[[ -f "$tmp/home/.config/notarchy/user.env" ]]
[[ -f "$tmp/home/.config/notarchy/hypr-user.conf" ]]
[[ -f "$tmp/home/.config/notarchy/waybar-style.css" ]]
[[ -f "$tmp/home/.config/notarchy/waybar-config.jsonc" ]]
grep -Fq 'NOTARCHY_WAYBAR_BACKGROUND=#c7c7c7' "$tmp/home/.config/notarchy/user.env"
grep -Fq '"include": "../waybar/default-config.jsonc"' "$tmp/home/.config/notarchy/waybar-config.jsonc"
[[ -L "$tmp/home/.bashrc" ]]
[[ "$(readlink "$tmp/home/.bashrc")" == "$repo_root/home/.bashrc" ]]

printf 'notarchy-apply test passed\n'
