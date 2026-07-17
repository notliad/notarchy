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

NotArchy started after almost a year of using Omarchy. I liked it, then I liked
customizing it, then I got tired of updates occasionally stepping on my personal
configs. So this is my own Arch installer: same kind of polished Hyprland setup,
but with my preferences baked in and a stricter rule that the system can update
without silently changing my personal setup.

It installs a complete encrypted Hyprland desktop with Ghostty, Walker, Waybar,
Mako, Nautilus, Google Chrome, VS Code, LocalSend, Helix, Neovim, Docker tools,
screenshot/OCR utilities, and a small NotArchy menu for install/remove/system
actions.

Omarchy is still the reference and inspiration. The nice ideas I like are copied
shamelessly, but deliberately; NotArchy does not vendor Omarchy or follow its
update/migration model.

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
