nixpkgs-unstable: _: prev:
let
  system = prev.stdenv.system;
  pkgs = nixpkgs-unstable.legacyPackages.${system};
in
{
  inherit (pkgs)
    faugus-launcher # Adds sleep blocking; Frequent updates
    ;
}
