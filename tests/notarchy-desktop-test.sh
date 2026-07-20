#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin"
ln -s /usr/bin/bash "$tmp/bin/bash"
ln -s "$(command -v jq)" "$tmp/bin/jq"

printf '#!/usr/bin/env bash\nprintf "firefox|%%s\\n" "$*"\n' > "$tmp/bin/firefox"
chmod +x "$tmp/bin/firefox"
output="$(PATH="$tmp/bin" "$repo_root/bin/notarchy-browser" --app=https://example.com --incognito --profile-directory=Default)"
[[ "$output" == 'firefox|--new-window https://example.com --private-window' ]]

printf '#!/usr/bin/env bash\nprintf "chrome|%%s\\n" "$*"\n' > "$tmp/bin/google-chrome-stable"
chmod +x "$tmp/bin/google-chrome-stable"
output="$(PATH="$tmp/bin" "$repo_root/bin/notarchy-browser" --app=https://example.com --profile-directory=Default)"
[[ "$output" == 'chrome|--app=https://example.com --profile-directory=Default' ]]

cat > "$tmp/bin/hyprctl" <<'HYPRCTL'
#!/usr/bin/env bash
printf '%s\n' '[{"class":"ghostty","title":"Shell","workspace":{"name":"special:scratchpad"}},{"class":"firefox","title":"Docs","workspace":{"name":"1"}}]'
HYPRCTL
chmod +x "$tmp/bin/hyprctl"
output="$(PATH="$tmp/bin" "$repo_root/config/waybar/modules/scratchpad.sh")"
[[ "$(jq -r .tooltip <<< "$output")" == Shell ]]
[[ -n "$(jq -r .text <<< "$output")" ]]

grep -Fq cerulean < <("$repo_root/bin/notarchy-waybar-theme" list)
grep -Fq '@define-color background #cc2936;' < <("$repo_root/bin/notarchy-waybar-theme" css jam)
XDG_CONFIG_HOME="$tmp/config" "$repo_root/bin/notarchy-waybar-theme" set olive
grep -Fq 'NOTARCHY_WAYBAR_THEME=olive' "$tmp/config/notarchy/user.env"
grep -Fq '@define-color muted #272838;' "$tmp/config/notarchy/waybar-style.css"

printf 'notarchy desktop test passed\n'
