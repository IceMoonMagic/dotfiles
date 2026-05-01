{
  description = "NixOS Config";

  inputs = {
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
    extra-flakes = {
      url = "path:./extra-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    { ... }@inputs:
    let
      inherit (import ./helpers.nix inputs) mkHomeManager mkNixosSystem mkNixosDesktop;
    in
    {
      formatter = inputs.nixpkgs.lib.genAttrs [
        "x86_64-linux"
        # "aarch64-linux"
        # "x86_64-darwin"
        # "aarch64-darwin"
      ] (system: inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree);

      homeConfigurations = {
        roboticat = mkHomeManager "x86_64-linux" [
          ./home/base.nix
          ./home/development/editors
          ./home/accounts/icemoon.git.nix
          ./home/accounts/roboticat.home.nix
        ];
      };

      nixosConfigurations = {
        pseudo-aurora = mkNixosDesktop [ ./system/hosts/pseudo-aurora/configuration.nix ];
        icemoon-y370 = mkNixosDesktop [ ./system/hosts/y370/configuration.nix ];
        t54 = mkNixosSystem [ ./system/hosts/t54/configuration.nix ];
      };
    };
}
