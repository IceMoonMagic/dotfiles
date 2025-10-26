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
    sshd-rando = {
      url = "path:./modules/sshd-rando";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (_: _: {
            inherit (import inputs.nixpkgs-unstable { inherit system; })
              headsetcontrol # SteelSeries Nova 5X undev rules
              heroic # Games fail to launch
              mission-center # GPU Graph
              satisfactorymodmanager # Doesn't build
              zed-editor # Option to disable AI features
              ;
            inherit (inputs.sshd-rando.packages.${system}) sshd-rando;
          })
        ];
      };
      registry = rec {
        register = path: {
          to = {
            type = "path";
            inherit path;
          };
        };
        # Allow `nix {run,shell} 'unstable#someProgram'
        # to match flake's nixpkgs/nixpkgs-unstable.
        system = {
          nix.registry.unstable = register inputs.nixpkgs-unstable;
        };
        # Ditto for 'nixpkgs#someProgram', not set by home-manager.
        # "option 'unstable' does not exist" for NixOS if done together.
        user = pkgs.lib.recursiveUpdate {
          nix.registry.nixpkgs = register nixpkgs;
        } system;
      };
      homeModules = [
        registry.user
        inputs.plasma-manager.homeModules.plasma-manager
      ];
      nixosModules = [
        inputs.disko.nixosModules.disko
        registry.system
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = homeModules;
        }
        inputs.nova-chatmix.nixosModules.x86_64-linux.default
      ];
      # `nix build '.#nixosConfigurations.*.config.system.build.isoImage'
      liveCDModule = [ (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix") ];
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
        test-os = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [ ./nixos/test-vm/configuration.nix ] ++ liveCDModule;
        };
      };
    };
}
