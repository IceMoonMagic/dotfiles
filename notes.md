# NixOS Notes
## Cheat Sheet
### NixOS Rebuild
- Check Configuration - `nixos-rebuild dry-build`
- Test Configuration - `sudo nixos-rebuild test`
- Use Configuration - `sudo nixos-rebuild switch`

### Nix Collect Garbage
- List Generations - `sudo nix-env --profile /nix/var/nix/profiles/system --list-generations`
- Delete Generations - `sudo nix-env --profile /nix/var/nix/profiles/system [--delete-generations # ...]>`
- Clean Up Store - `nix-collect-garbage

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
  - `nixos-rebuild build-image --flake '<flake>#<host>' --image-variant iso-installer`

### In live session
1. Generate hardware config
  - `sudo nixos-generate-config --show-hardware-config > <path/to/host/hardware-configuartion.nix>`
1. Login to Netbird
1. Update Config:
  - Set SSH listen address to Netbird IP
  - Un-disable SSH
  - Set Disko `/dev/disk/by-id/<id>`
1. Format via Disko
  - `sudo nix run disko -- --mode destroy,format,mount <path/to/host/disko.nix>`
1. Install NixOS
  - TODO: Use install media's nixpkgs instead of downloading
  - `sudo nixos-install --flake '<flake>#<host>'`
1. Enter the new NixOS (auto?)
  - `sudo nixos-enter --root <new-root>`
1. Update passwords
  - `sudo passwd --lock root`
  - `sudo passwd <username>`
1. Transfer `/var/lib/netbird`
1. Transfer `.` to `/etc/nixos`
  - Optionally, chown / chmod

## Home Manager
### Post Setup
- Accounts - Sign in to desired accounts
