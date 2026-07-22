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

## Install from the Arch ISO 

Before starting, back up the target disk, boot the official Arch ISO in UEFI
mode, and connect to the internet. For Wi-Fi, use `iwctl` from the ISO.

Download and inspect the bootstrap before running it:

```sh
curl -fLo /tmp/notarchy-boot https://raw.githubusercontent.com/notliad/notarchy/master/boot.sh
less /tmp/notarchy-boot
bash /tmp/notarchy-boot
```

Pass `--ref TAG_OR_COMMIT` to install a reviewed release or commit instead of
the current default branch. To install manually:

```sh
pacman -Syu --needed git gum rsync curl
git clone https://github.com/notliad/notarchy.git /tmp/notarchy
cd /tmp/notarchy
./install/notarchy-install
```

The installer shows five stages, rejects mounted disks and disks smaller than
20 GiB, displays the selected disk's partitions, and requires its full device
path before erasing it. Disk encryption and the user account use separate
passwords; the root account is locked.

Software profiles:

- **Essential** (default): a usable Hyprland desktop and its required tools.
- **NotArchy defaults**: the complete opinionated package set listed in
  `packages/pacman.txt` and `packages/aur.txt`.
- **Custom selection**: Essential plus a checklist of optional applications and
  tool bundles.

Preview installer commands without touching a disk:

```sh
./install/notarchy-install --dry-run --profile essential --disk /dev/vda \
  --hostname notarchy --username user \
  --disk-password-file /path/to/password \
  --user-password-file /path/to/password --yes
```

Custom unattended installs accept `--profile custom --programs chrome,docker`.
Run `./install/notarchy-install --help` for all options.

Local checks:

```sh
scripts/test-dry-run
tests/notarchy-desktop-test.sh
scripts/test-vm --reset
```

## Daily Use

```sh
notarchy-apply
```
`notarchy-apply` copies every file under `config/` to the matching path under
`$HOME/.config`. Existing different files are moved to `.bak.<timestamp>` first.


```sh
notarchy-update
```
`notarchy-update` updates system packages, AUR packages, and pulls this repo. It
does not change active configs automatically. Run `notarchy-apply` when you want
new tracked defaults. First login offers an optional three-step personalization
flow for timezone, Waybar appearance, and modules.

Useful shortcuts:

- `Super + Space`: app launcher
- `Super + Alt + Space`: NotArchy menu
- `Super + Esc`: system menu
- `Print`: screenshot
- `Super + Print`: OCR selection
- `Super + Shift + X`: color picker
- `Super + Ctrl + Space`: next wallpaper

More implementation detail lives in [TECHNICAL_CONTEXT.md](TECHNICAL_CONTEXT.md).
