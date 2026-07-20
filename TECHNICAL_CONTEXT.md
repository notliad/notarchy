# NotArchy Technical Context

NotArchy is a personal Arch Linux base system inspired by Omarchy, but it does
not inherit Omarchy's update model. This repository is the source of truth for
the installer, package lists, user commands, and default desktop configuration.

The installer starts from the official Arch ISO, wipes one selected disk, and
builds a complete UEFI system with `systemd-boot`, LUKS, Btrfs subvolumes, and a
Hyprland desktop. It installs this repository into
`~/.local/share/notarchy`, symlinks every `bin/notarchy-*` command into
`/usr/local/bin`, and copies tracked configuration into the target user's home.
This keeps routine repository updates separate from active user configuration.

## Software Profiles

The installer offers three profiles:

- Essential is the default and installs `packages/pacman-essential.txt` plus
  `packages/aur-essential.txt`.
- NotArchy defaults installs the complete opinionated package set in
  `packages/pacman.txt` and `packages/aur.txt`.
- Custom starts with Essential and adds selections from `packages/options.tsv`.

The complete NotArchy defaults profile includes:

- Core Arch packages: `base`, `base-devel`, `linux`, firmware, CPU microcode,
  Btrfs, LUKS, EFI boot tools, `sudo`, `git`, `go`, `gum`, NetworkManager,
  Bluetooth, power profiles, and Plymouth.
- Desktop stack: Hyprland, Hypridle, Hyprlock, Hyprpicker, XDG desktop portals,
  Waybar, greetd/tuigreet, Ghostty, Nautilus, Mako, Polkit GNOME, PipeWire,
  WirePlumber, Swaybg, UWSM, clipboard/screenshot/OCR tools, and Nerd Fonts.
- Graphical apps: GNOME Calculator, Evince, KolourPaint, nwg-displays, Google
  Chrome, VS Code, LocalSend, Walker, Elephant providers, Mutui, and Liftoff.
- CLI and TUI tools: `bash-completion`, `bluetui`, `btop`, `curl`, Docker,
  `eza`, Fastfetch, `fzf`, Helix, `impala`, `jq`, Lazydocker, Lazygit, `less`,
  `man-db`, Neovim, `playerctl`, Ripgrep, Rsync, Starship, Tmux, Unzip,
  `wiremix`, and Zoxide.

AUR/proprietary packages are installed after `yay` is bootstrapped. They remain
separate from official packages so third-party package decisions stay visible.

## Default Desktop

The desktop is Hyprland with Ghostty as the default terminal, Walker as the app
launcher, Waybar as the panel, Mako for notifications, and `greetd + tuigreet`
for login. Hyprland configuration is split by responsibility:

- `config/hypr/hyprland.conf`: entrypoint that sources all other Hyprland files.
- `config/hypr/bindings.conf`: app launchers, capture shortcuts, workspaces, and
  power/system menu shortcuts.
- `config/hypr/looknfeel.conf`: gaps, zero borders, rounded corners, shadow,
  dimming, and HyprMod-derived animation curves.
- `config/hypr/windows.conf`: window rules for NotArchy floating TUI tools.
- `config/hypr/workspaces.conf`: optional local workspace rules. Defaults do not
  assume specific display names.
- `config/hypr/input.conf`, `envs.conf`, `autostart.conf`, `hypridle.conf`,
  `hyprlock.conf`, and `hyprsunset.conf`: input, environment, startup, idle,
  lock screen, and night light behavior.

Default key workflows include:

- `Super + Space`: Walker launcher.
- `Super + Alt + Space`: NotArchy main menu.
- `Super + Esc`: NotArchy system menu.
- `Print`: screenshot.
- `Super + Print`: OCR from screen selection.
- `Super + Shift + X`: color picker.
- `Super + Ctrl + Space`: rotate wallpaper.

Wallpapers are copied from `assets/wallpapers/` into `~/Pictures/wallpapers`
during installation. `notarchy-wallpaper` uses that directory by default and
stores the active wallpaper symlink in `~/.config/notarchy/background`.

## Default App Configuration

Tracked configs under `config/` are copied into `$HOME/.config` by
`notarchy-apply`. Existing different files are backed up first.

- Ghostty uses the TokyoNight theme, JetBrainsMono Nerd Font at 12px, padded
  windows, block cursor, clipboard keybinds, CSI-u keybinds for terminal/Tmux
  compatibility, slower mouse scrolling, and the `epoll` async backend for
  Hyprland responsiveness.
- Helix uses the `onedarker` theme, relative line numbers, block/bar/underline
  cursor shapes per mode, and a file picker that shows hidden files.
- Starship provides the shell prompt, with a compact directory/git/sudo format
  and Catppuccin Frappe colors.
- Walker is configured with the NotArchy theme, keyboard focus, wrapped
  selection, desktop applications and web search as default providers, and
  prefix providers for files, symbols, calculator, web search, clipboard, and
  provider selection.
- Waybar provides workspaces, system status, weather, scratchpad status, and
  utility hooks into NotArchy commands.
- Mako is the notification daemon.
- `home/.local/share/applications/*.desktop` contains `NoDisplay=true`
  overrides for utility desktop entries that should not clutter the launcher.

## NotArchy Commands

Installed commands are named `notarchy-*` and are linked into `/usr/local/bin`.
The important user-facing commands are:

- `notarchy-apply`: copy tracked config and home files into the user's home.
  Existing different files are moved to `.bak.<timestamp>` before copying.
- `notarchy-update`: update system packages, AUR packages, and pull this repo,
  but never reapply configs automatically.
- `notarchy-menu`: Walker-based main menu. Current top-level menus are Install,
  Remove, and System.
- `notarchy-pkg-install`, `notarchy-pkg-aur-install`, `notarchy-pkg-remove`:
  fzf-based package search/install/remove flows modeled after Omarchy.
- `notarchy-capture-screenshot` and `notarchy-capture-ocr`: screenshot and OCR
  helpers using Hyprpicker, Slurp, Grim, Satty, Tesseract, and Wl-clipboard.
- `notarchy-wallpaper`: select, rotate, and reapply wallpapers from
  `~/Pictures/wallpapers`.
- `notarchy-launch-walker`: starts Walker and Elephant services before invoking
  Walker.
- `notarchy-floating-tui`: launches supported TUI tools in floating Ghostty
  windows.

## Update Philosophy

NotArchy treats this repository as a declarative source of truth at install time,
but it does not force configuration changes onto an installed system during
routine updates.

`notarchy-update` does three things only:

1. Runs `pacman -Syu --needed` when `pacman` exists.
2. Runs `yay -Syu --needed` when `yay` exists.
3. Pulls this repository with `git pull --ff-only`.

It explicitly prints that active configs were not changed. This is intentional:
updating packages and fetching repo changes should not silently overwrite user
configuration. Applying new defaults is a manual action:

```sh
notarchy-apply
```

The model is: update safely and frequently, apply config deliberately.

## Relationship To Omarchy

Omarchy is a reference, not an upstream dependency. Useful pieces can be copied
deliberately, but NotArchy does not vendor Omarchy, submodule it, or merge from
it automatically. This keeps NotArchy smaller, easier to audit, and independent
from Omarchy's release and migration flow.
