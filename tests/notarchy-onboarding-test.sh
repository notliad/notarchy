#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

HOME="$tmp/ensure-home" \
XDG_CONFIG_HOME="$tmp/ensure-home/.config" \
NOTARCHY_ONBOARDING_SKIP_APPLY=1 \
  "$repo_root/bin/notarchy-onboarding" --ensure-defaults

[[ -f "$tmp/ensure-home/.config/notarchy/user.env" ]]
[[ -f "$tmp/ensure-home/.config/notarchy/waybar-style.css" ]]
[[ -f "$tmp/ensure-home/.config/notarchy/waybar-config.jsonc" ]]
[[ ! -e "$tmp/ensure-home/.config/notarchy/onboarding-seen" ]]

HOME="$tmp/home" \
XDG_CONFIG_HOME="$tmp/home/.config" \
NOTARCHY_NO_GUM=1 \
NOTARCHY_ONBOARDING_SKIP_APPLY=1 \
NOTARCHY_ONBOARDING_BACKGROUND='#112233' \
NOTARCHY_ONBOARDING_FOREGROUND='#ddeeff' \
NOTARCHY_ONBOARDING_MODULES='hyprland/workspaces,clock,custom/weather,network,battery' \
NOTARCHY_ONBOARDING_KEYBOARD_LAYOUT='us,br' \
NOTARCHY_ONBOARDING_KEYBOARD_VARIANT=',abnt2' \
NOTARCHY_ONBOARDING_TIMEZONE='America/Sao_Paulo' \
NOTARCHY_ONBOARDING_LOCATION='Juazeiro' \
  "$repo_root/bin/notarchy-onboarding" --first-run

config="$tmp/home/.config/notarchy"
[[ -f "$config/onboarding-seen" ]]
grep -Fq 'NOTARCHY_LOCATION=Juazeiro' "$config/user.env"
grep -Fq 'NOTARCHY_TIMEZONE=America/Sao_Paulo' "$config/user.env"
grep -Fq 'NOTARCHY_WAYBAR_BACKGROUND=\#112233' "$config/user.env"
grep -Fq 'kb_layout = us,br' "$config/hypr-user.conf"
grep -Fq 'kb_variant = ,abnt2' "$config/hypr-user.conf"
grep -Fq '@define-color background #112233;' "$config/waybar-style.css"
grep -Fq '"modules-left": ["group/left-modules"]' "$config/waybar-config.jsonc"
grep -Fq '"modules-center": ["group/clock-weather", "custom/spacer"]' "$config/waybar-config.jsonc"
grep -Fq '"modules-right": ["group/right-modules", "battery"]' "$config/waybar-config.jsonc"
grep -Fq '"modules": ["clock", "custom/weather"]' "$config/waybar-config.jsonc"
grep -Fq '"modules": ["network"]' "$config/waybar-config.jsonc"

printf 'notarchy-onboarding test passed\n'
