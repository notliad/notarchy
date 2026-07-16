# Notarchy

Personal Arch Linux base inspired by Omarchy, without inheriting Omarchy's update
model. This repository is the source of truth for Notarchy configs.

## V1 contract

- Start from the official Arch ISO.
- Run `install/notarchy-install` from the live environment.
- Wipe one selected disk after exact path confirmation.
- Install UEFI + `systemd-boot` + LUKS + Btrfs.
- Install a lean Hyprland desktop with Ghostty, Google Chrome stable, VS Code,
  Waybar, Walker, and `greetd + tuigreet`.
- Apply configs as symlinks from this repo into `~/.config`.
- `notarchy-update` updates packages/repo only. It never reapplies configs.

Omarchy is a reference only. Copy useful pieces deliberately; do not vendor it,
submodule it, or merge from it automatically.

## Live ISO usage

From the official Arch ISO:

```sh
pacman -Sy --needed git
git clone <your-notarchy-repo-url> /tmp/notarchy
cd /tmp/notarchy
./install/notarchy-install
```

Review without executing destructive commands:

```sh
./install/notarchy-install --dry-run
```

## Installed-system commands

```sh
notarchy-apply
notarchy-update
```

`notarchy-apply` links every file under `config/` to the matching path under
`$HOME/.config`. Existing real files are moved to `.bak.<timestamp>` first.
The installer links these commands into `/usr/local/bin`.
