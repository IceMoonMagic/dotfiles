{
  description = "NixOS Config";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays =
          let
            unstable = import inputs.nixpkgs-unstable { inherit system; };
          in
          [
            (final: prev: {
              headsetcontrol = unstable.headsetcontrol; # SteelSeries Nova 5X undev rules
              heroic = unstable.heroic; # Games fail to launch
              zed-editor = unstable.zed-editor; # Option to disable AI features
            })
          ];
      };
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
        inherit pkgs;
          modules = [ ./home/home.nix ] ++ homeModules;
        };
      };
      nixosConfigurations = {
        pseudo-aurora = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [ ./nixos/pseudo-aurora/configuration.nix ] ++ nixosModules;
        };
        icemoon-y370 = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [ ./nixos/y370/configuration.nix ] ++ nixosModules;
        };
      };
    };
}
