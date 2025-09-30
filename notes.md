# NixOS Notes
## Cheat Sheet
### NixOS Rebuild
- Check Configuration - `nixos-rebuild dry-build`
- Test Configuration - `sudo nixos-rebuild test`
- Use Configuration - `sudo nixos-rebuild switch`

### Nix Shell
- Old - `nix-shell -p <package-name>`
- New - `nix shell 'nixpkgs#<package-name>'`


## Install NixOS
### Available before access to device
1. Create a new folder `./nixos/<hostname>`
1. Create a `./nixos/<hostname>/configuration.nix`
  - Disable SSH (for now)
  - Try to keep simple
  - Break large sections into own file
1. Create a `./nixos/<hostname>/disko.nix`
1. Add output to `./flake.nix`
1. Create a install iso based on configuration
  - TODO

### In live session
1. Login to Netbird
1. Update Config:
  - Set SSH listen address to Netbird IP
  - Un-disable SSH
  - Set Disko `/dev/disk/by-id/<id>`
1. Format via Disko
1. Install NixOS
1. Enter the new NixOS (auto?)
1. Update passwords
  - `sudo passwd <username>`
1. Transfer `/var/lib/netbird`
1. Transfer `.` to `/etc/nixos`
  - Optionally, chown / chmod

## Home Manager
### Post Setup
- Accounts - Sign in to desired accounts
- KDE Kate - Hamburger Menu (Open Menu / F10) > Sort By > Hidden Files Last
