#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/home/.config/ghostty"
printf 'old\n' > "$tmp/home/.config/ghostty/config"
cp -a "$repo_root/config" "$tmp/source-config"
mkdir -p "$tmp/source-home"
cp -a "$repo_root/home/." "$tmp/source-home/"

NOTARCHY_CONFIG_ROOT="$tmp/source-config" \
NOTARCHY_TARGET_CONFIG_ROOT="$tmp/home/.config" \
NOTARCHY_HOME_ROOT="$tmp/source-home" \
NOTARCHY_TARGET_HOME="$tmp/home" \
NOTARCHY_BACKUP_TIMESTAMP=123 \
  "$repo_root/bin/notarchy-apply"

[[ -f "$tmp/home/.config/ghostty/config" && ! -L "$tmp/home/.config/ghostty/config" ]]
[[ "$(cat "$tmp/home/.config/ghostty/config.bak.123")" == old ]]
[[ -f "$tmp/home/.config/hypr/hyprland.conf" && ! -L "$tmp/home/.config/hypr/hyprland.conf" ]]
[[ -f "$tmp/home/.config/waybar/default-style.css" ]]
[[ -f "$tmp/home/.config/waybar/default-config.jsonc" ]]
[[ -f "$tmp/home/.config/notarchy/user.env" ]]
[[ -f "$tmp/home/.config/notarchy/hypr-user.conf" ]]
[[ -f "$tmp/home/.config/notarchy/waybar-style.css" ]]
[[ -f "$tmp/home/.config/notarchy/waybar-config.jsonc" ]]
grep -Fq 'NOTARCHY_WAYBAR_THEME=silver' "$tmp/home/.config/notarchy/user.env"
grep -Fq 'NOTARCHY_WAYBAR_BACKGROUND=#c7c7c7' "$tmp/home/.config/notarchy/user.env"
grep -Fq '@define-color accent #427aa1;' "$tmp/home/.config/notarchy/waybar-style.css"
grep -Fq '"include": "../waybar/default-config.jsonc"' "$tmp/home/.config/notarchy/waybar-config.jsonc"
[[ -f "$tmp/home/.bashrc" && ! -L "$tmp/home/.bashrc" ]]

printf 'changed upstream\n' > "$tmp/source-config/ghostty/config"
[[ "$(cat "$tmp/home/.config/ghostty/config")" != 'changed upstream' ]]

sed -i 's/mpris/custom\/mpris/' "$tmp/home/.config/notarchy/user.env" "$tmp/home/.config/notarchy/waybar-config.jsonc"
NOTARCHY_CONFIG_ROOT="$tmp/source-config" \
NOTARCHY_TARGET_CONFIG_ROOT="$tmp/home/.config" \
NOTARCHY_HOME_ROOT="$tmp/source-home" \
NOTARCHY_TARGET_HOME="$tmp/home" \
NOTARCHY_BACKUP_TIMESTAMP=124 \
  "$repo_root/bin/notarchy-apply"
! grep -q 'custom/mpris' "$tmp/home/.config/notarchy/user.env"
! grep -q 'custom/mpris' "$tmp/home/.config/notarchy/waybar-config.jsonc"

printf '@define-color background #111111;\n@define-color foreground #eeeeee;\n' > "$tmp/home/.config/notarchy/waybar-style.css"
NOTARCHY_CONFIG_ROOT="$tmp/source-config" \
NOTARCHY_TARGET_CONFIG_ROOT="$tmp/home/.config" \
NOTARCHY_HOME_ROOT="$tmp/source-home" \
NOTARCHY_TARGET_HOME="$tmp/home" \
NOTARCHY_BACKUP_TIMESTAMP=125 \
  "$repo_root/bin/notarchy-apply"
grep -Fq '@define-color critical #cc2936;' "$tmp/home/.config/notarchy/waybar-style.css"

printf 'notarchy-apply test passed\n'
