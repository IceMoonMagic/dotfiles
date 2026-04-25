{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    abiotic-factor = {
      url = "path:./abiotic-factor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nova-chatmix = {
      url = "github:icemoonmagic/nova-chatmix-linux/Rework";
      #url = "path:/home/roboticat/Projects/nova-chatmix-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sshd-rando = {
      url = "path:./sshd-rando";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      lib = inputs.nixpkgs.lib;
      flakes = with inputs; [
        abiotic-factor
        nova-chatmix
        sshd-rando
      ];
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = lib.genAttrs supportedSystems;
      combineFlakesAttr =
        let
          filterDefault = lib.filterAttrs (name: _: name != "default");
          update = r: attr: lib.recursiveUpdate r (filterDefault attr);
          op = attr: (f: r: if builtins.hasAttr attr f then update r f.${attr} else r);
        in
        attr: lib.foldr (op attr) { } flakes;
    in
    rec {
      formatter = forEachSystem (system: inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree);
      nixosModules = combineFlakesAttr "nixosModules";
      nixosModulesList = builtins.attrValues nixosModules;
      overlays.default =
        final: prev:
        let
          system = prev.stdenv.system;
        in
        if builtins.hasAttr system packages then packages.${system} else { };
      packages = combineFlakesAttr "packages";
    };
}
