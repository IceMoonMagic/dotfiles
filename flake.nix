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
      mkHomeManager =
        modules:
        home-manager.lib.homeManagerConfiguration {
          inherit modules;
          specialArgs = { inherit inputs registry; };
        };
      mkNixosSystem =
        modules:
        nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs = { inherit inputs registry; };
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
        roboticat = mkHomeManager [ ./home/home.nix ];
      };

      nixosConfigurations = {
        pseudo-aurora = mkNixosSystem [ ./nixos/pseudo-aurora/configuration.nix ];
        icemoon-y370 = mkNixosSystem [ ./nixos/y370/configuration.nix ];
        t54 = mkNixosSystem [ ./nixos/t54/configuration.nix ];
      };
    };
}
