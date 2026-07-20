#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

HOME="$tmp/ensure-home" \
XDG_CONFIG_HOME="$tmp/ensure-home/.config" \
NOTARCHY_NO_ZENITY=1 \
NOTARCHY_ONBOARDING_SKIP_APPLY=1 \
  "$repo_root/bin/notarchy-onboarding" --ensure-defaults

[[ -f "$tmp/ensure-home/.config/notarchy/user.env" ]]
[[ -f "$tmp/ensure-home/.config/notarchy/waybar-style.css" ]]
[[ -f "$tmp/ensure-home/.config/notarchy/waybar-config.jsonc" ]]
[[ ! -e "$tmp/ensure-home/.config/notarchy/onboarding-seen" ]]
grep -Fq '@define-color accent #427aa1;' "$tmp/ensure-home/.config/notarchy/waybar-style.css"

HOME="$tmp/home" \
XDG_CONFIG_HOME="$tmp/home/.config" \
NOTARCHY_NO_ZENITY=1 \
NOTARCHY_NO_GUM=1 \
NOTARCHY_ONBOARDING_SKIP_APPLY=1 \
NOTARCHY_ONBOARDING_ACTION=personalize \
NOTARCHY_ONBOARDING_THEME=cerulean \
NOTARCHY_ONBOARDING_MODULES='hyprland/workspaces,clock,custom/weather,network,battery' \
NOTARCHY_ONBOARDING_TIMEZONE='America/Sao_Paulo' \
NOTARCHY_ONBOARDING_LOCATION='Juazeiro' \
  "$repo_root/bin/notarchy-onboarding" --first-run

config="$tmp/home/.config/notarchy"
[[ -f "$config/onboarding-seen" ]]
grep -Fq 'NOTARCHY_LOCATION=Juazeiro' "$config/user.env"
grep -Fq 'NOTARCHY_TIMEZONE=America/Sao_Paulo' "$config/user.env"
grep -Fq 'NOTARCHY_WAYBAR_THEME=cerulean' "$config/user.env"
grep -Fq 'NOTARCHY_WAYBAR_BACKGROUND=\#427aa1' "$config/user.env"
grep -Fq 'kb_layout = br' "$config/hypr-user.conf"
grep -Fq 'kb_variant = abnt2' "$config/hypr-user.conf"
grep -Fq '@define-color background #427aa1;' "$config/waybar-style.css"
grep -Fq '@define-color critical #cc2936;' "$config/waybar-style.css"
grep -Fq '"modules-left": ["group/left-modules"]' "$config/waybar-config.jsonc"
grep -Fq '"modules-center": ["group/clock-weather", "custom/spacer"]' "$config/waybar-config.jsonc"
grep -Fq '"modules-right": ["group/right-modules", "battery"]' "$config/waybar-config.jsonc"
grep -Fq '"modules": ["clock", "custom/weather"]' "$config/waybar-config.jsonc"
grep -Fq '"modules": ["network"]' "$config/waybar-config.jsonc"

if HOME="$tmp/fail-home" \
  XDG_CONFIG_HOME="$tmp/fail-home/.config" \
  NOTARCHY_NO_ZENITY=1 \
  NOTARCHY_NO_GUM=1 \
  NOTARCHY_ONBOARDING_SKIP_APPLY=1 \
  NOTARCHY_ONBOARDING_ACTION=personalize \
  NOTARCHY_ONBOARDING_BACKGROUND=invalid \
  NOTARCHY_ONBOARDING_FOREGROUND='#ddeeff' \
  NOTARCHY_ONBOARDING_MODULES=clock \
  NOTARCHY_ONBOARDING_TIMEZONE=UTC \
    "$repo_root/bin/notarchy-onboarding" --first-run 2>/dev/null; then
  printf 'Invalid onboarding unexpectedly succeeded.\n' >&2
  exit 1
fi
[[ ! -e "$tmp/fail-home/.config/notarchy/onboarding-seen" ]]

HOME="$tmp/skip-home" \
XDG_CONFIG_HOME="$tmp/skip-home/.config" \
NOTARCHY_NO_ZENITY=1 \
NOTARCHY_NO_GUM=1 \
NOTARCHY_ONBOARDING_ACTION=skip \
  "$repo_root/bin/notarchy-onboarding" --first-run
[[ -f "$tmp/skip-home/.config/notarchy/onboarding-seen" ]]

printf 'notarchy-onboarding test passed\n'
