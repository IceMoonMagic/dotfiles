{
  description = "NixOS Config";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nova-chatmix = {
      url = "github:icemoonmagic/nova-chatmix-linux/Rework";
      #url = "path:/home/roboticat/Projects/nova-chatmix-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      home-manager,
      plasma-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      homeModules = [ plasma-manager.homeModules.plasma-manager ];
      nixosModules = [
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
        }
        inputs.nova-chatmix.nixosModules.x86_64-linux.default
      ];
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;
      homeConfigurations = {
        roboticat = home-manager.lib.homeManagerConfiguration {
          modules = [ ./home/home.nix ] ++ homeModules;
        };
      };
      nixosConfigurations = {
        pseudo-aurora = nixpkgs.lib.nixosSystem {
          modules = [ ./nixos/pseudo-aurora/configuration.nix ]++ nixosModules;
        };
        icemoon-y370 = nixpkgs.lib.nixosSystem {
          modules = [ ./nixos/y370/configuration.nix ] ++ nixosModules;
        };
      };
    };
}
