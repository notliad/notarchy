#!/usr/bin/env bash
set -euo pipefail

hyprctl clients -j | jq -c '
  [.[] | select(.workspace.name == "special:scratchpad")] as $apps
  | if ($apps | length) == 0 then {text: ""}
    else {
      text: ($apps | map(
        if (.class | test("^(kitty|Alacritty|foot|ghostty)$")) then ""
        elif (.class | test("^[Ff]irefox$")) then ""
        elif (.class | test("^(chromium|Chromium|google-chrome|Google-chrome)$")) then ""
        elif (.class | test("^[Cc]ode$")) then ""
        elif (.class | test("^[Ss]potify$")) then ""
        elif (.class | test("^[Dd]iscord$")) then ""
        elif (.class | test("^(thunar|Thunar|nautilus|Nautilus)$")) then ""
        elif (.class | test("^[Mm]utui$")) then ""
        else "" end
      ) | join(" ")),
      tooltip: ($apps | map(.title) | join("\n"))
    } end
'
