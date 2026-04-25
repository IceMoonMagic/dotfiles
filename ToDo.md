## Broken
### Errors
See `journalctl -b -p err`

- `kernel: RDSEED32 is broken. Disabling the corresponding CPUID bit`
- `systemd[1487]: basic.target: Found ordering cycle: home-manager.service/start after basic.target/start - after home-manager.service`
- `systemd[1487]: basic.target: Found ordering cycle: home-manager.service/start after basic.target/start - after home-manager.service`
- `systemd[1740]: basic.target: Found ordering cycle: home-manager.service/start after basic.target/start - after home-manager.service`
- `systemd[1740]: basic.target: Found ordering cycle: home-manager.service/start after basic.target/start - after home-manager.service`
- `systemd[1740]: Failed to start Run user-specific NixOS activation.`
- `org_kde_powerdevil[2217]: [  2217] busno=14, All features that should not exist detected. Monitor does not indicate unsupported`

### Warnings
See `journalctl -b -p warning`
> Not listed due to quantity


## Missing Configuration
- [ ] Unified Theming
  - [ ] KDE
  - [ ] Terminal | set / use term colors
    - [ ] Dir Colors
    - [ ] Zsh Syntax Highlighting
    - [ ] Oh My Posh
- [ ] Game Launchers
  - [ ] Steam Settings
  - [ ] Heroic Settings
- [ ] Editors
  <!--- [ ] Jetbrains
    - [ ] Colors
    - [ ] Plugins
    - [ ] Overall Settings-->
  - [ ] Godot
    - [ ] Colors
    - [ ] Overall Settings
  - [ ] Kate
    - [ ] Colors (Unified Theming / KDE)
    - [ ] Indent Width
  - [ ] Zed
    - [ ] Colors
    - [x] Overall Settings
- [ ] OpenRGB / Artemis
- [x] Firefox
  - [x] Base Extensions
  - [x] Base Settings
- [ ] Seamless system vs hm
  - [ ] Install packages @ system if nixos, else user
  - [ ] HM Enable config but no install
