{
  description = "NixOS Config";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nova-chatmix = {
      url = "github:icemoonmagic/nova-chatmix-linux/Rework";
      # url = "path:/home/roboticat/Projects/nova-chatmix-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sshd-rando = {
      url = "path:./modules/sshd-rando";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    abiotic-factor = {
      url = "path:./modules/abiotic-factor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      registry =
        let
          register = path: {
            to.type = "path";
            to.path = path;
          };
        in
        {
          # Allow `nix {run,shell} {nixpkgs,unstable}#someProgram`
          # to match this flake's nixpkgs nixpkgs / nixpkgs-unstable.
          nix.registry.nixpkgs = register nixpkgs;
          nix.registry.unstable = register inputs.nixpkgs-unstable;
        };
      homeModules = [
        inputs.plasma-manager.homeModules.plasma-manager
        registry
      ];
      mkHomeManager =
        system: modules:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules =
            modules
            ++ homeModules
            ++ [
              ./system/modules/defaults/nix.nix
              overlays
              {
                nixpkgs.system = system;
                nix.package = pkgs.nix;
              }
            ];
        };
      mkNixosSystem =
        modules:
        nixpkgs.lib.nixosSystem {
          modules = modules ++ [
            inputs.disko.nixosModules.disko
            inputs.home-manager.nixosModules.home-manager
            inputs.nova-chatmix.nixosModules.nova-chatmix
            inputs.abiotic-factor.nixosModules.abiotic-server
            registry
            overlays
            ./system/modules
          ];
          specialArgs = { inherit homeModules; };
        };
      mkNixosDesktop = modules: mkNixosSystem (modules ++ [ ./system/modules/defaults/desktops ]);
      overlays = {
        nixpkgs.overlays = [ inputs.sshd-rando.overlays.default ];
      };
    in
    {
      formatter = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        # "aarch64-linux"
        # "x86_64-darwin"
        # "aarch64-darwin"
      ] (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      homeConfigurations = {
        roboticat = mkHomeManager "x86_64-linux" [ ./home/home.nix ];
      };

      nixosConfigurations = {
        pseudo-aurora = mkNixosDesktop [ ./system/hosts/pseudo-aurora/configuration.nix ];
        icemoon-y370 = mkNixosDesktop [ ./system/hosts/y370/configuration.nix ];
        t54 = mkNixosDesktop [ ./system/hosts/t54/configuration.nix ];
      };
    };
}
