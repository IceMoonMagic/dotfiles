inputs:
let
  overlays = {
    nixpkgs.overlays = [
      inputs.extra-flakes.overlays.default
      (import ./unstable-packages.nix inputs.nixpkgs-unstable)
    ];
  };
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
      nix.registry.nixpkgs = register inputs.nixpkgs;
      nix.registry.unstable = register inputs.nixpkgs-unstable;
    };
  homeModules = [
    inputs.plasma-manager.homeModules.plasma-manager
    registry
  ];
  homeModulesStandalone = system: pkgs: [
    {
      nixpkgs.system = system;
      nix.package = pkgs.nix;
    }
    overlays
    ./system/modules/defaults/nix.nix
  ];
  systemModules = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    registry
    overlays
    ./system/modules
  ]
  ++ (builtins.attrValues inputs.extra-flakes.nixosModules);
in
rec {
  mkHomeManager =
    system: extraModules:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = extraModules ++ homeModules ++ (homeModulesStandalone system pkgs);
    };
  mkNixosSystem =
    extraModules:
    inputs.nixpkgs.lib.nixosSystem {
      modules = extraModules ++ systemModules;
      specialArgs = { inherit homeModules inputs; };
    };
  mkNixosDesktop =
    extraModules: mkNixosSystem (extraModules ++ [ ./system/modules/defaults/desktops ]);
}
