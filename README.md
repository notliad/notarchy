<div align="center">
<pre>
▄▄▄    ▄▄▄               ▄▄▄▄               ▄▄          
████▄  ███        ██   ▄██▀▀██▄             ██          
███▀██▄███ ▄███▄ ▀██▀▀ ███  ███ ████▄ ▄████ ████▄ ██ ██ 
███  ▀████ ██ ██  ██   ███▀▀███ ██ ▀▀ ██    ██ ██ ██▄██ 
███    ███ ▀███▀  ██   ███  ███ ██    ▀████ ██ ██  ▀██▀ 
                                                    ██  
                                                  ▀▀▀
</pre>
</div>

Personal Arch Linux setup inspired by Omarchy, but kept independent and small.
It installs a complete encrypted Hyprland desktop and keeps this repository as
the source of truth for packages, scripts, and default configs.

NotArchy includes Ghostty, Walker, Waybar, Mako, Nautilus, Google Chrome, VS
Code, LocalSend, Helix, Neovim, Docker tools, screenshot/OCR utilities, and a
small NotArchy menu for install/remove/system actions.

Omarchy is only a reference. Useful ideas are copied deliberately; NotArchy does
not vendor Omarchy or follow its update/migration model.

## Live ISO usage

From the official Arch ISO:

```sh
curl -fsSL https://raw.githubusercontent.com/notliad/notarchy/master/boot.sh | bash
```

Or manually:

```sh
pacman -Sy --needed git
git clone https://github.com/notliad/notarchy.git /tmp/notarchy
cd /tmp/notarchy
./install/notarchy-install
```

Preview installer commands without touching a disk:

```sh
./install/notarchy-install --dry-run
```

Local checks:

```sh
scripts/test-dry-run
scripts/test-vm --reset
```

## Daily Use

```sh
notarchy-apply
notarchy-update
```

`notarchy-apply` links every file under `config/` to the matching path under
`$HOME/.config`. Existing real files are moved to `.bak.<timestamp>` first.

`notarchy-update` updates system packages, AUR packages, and pulls this repo. It
does not reapply configs automatically. Run `notarchy-apply` when you want new
tracked config changes.

Useful shortcuts:

- `Super + Space`: app launcher
- `Super + Alt + Space`: NotArchy menu
- `Super + Esc`: system menu
- `Print`: screenshot
- `Super + Print`: OCR selection
- `Super + Shift + X`: color picker
- `Super + Ctrl + Space`: next wallpaper

More implementation detail lives in [TECHNICAL_CONTEXT.md](TECHNICAL_CONTEXT.md).
