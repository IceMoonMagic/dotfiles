nixpkgs: nixpkgs-unstable: _: prev:
let
  system = prev.stdenv.system;
  pkgs = nixpkgs.legacyPackages.${system};
  pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
in
{
  inherit (pkgs-unstable)
    ;
  satisfactorymodmanager = pkgs.satisfactorymodmanager.overrideAttrs rec {
    pname = "satisfactorymodmanager";
    version = "3.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "satisfactorymodding";
      repo = "SatisfactoryModManager";
      tag = "v${version}";
      hash = "sha256-X8uky9+FhtaAHMY6XrvTZTo3mILcWnlrjq/1SJ9UBkw=";
    };
    vendorHash = "sha256-a8o69vrW6TfrYmBRlSNE4NqemJUBFQilsVj+qwLYcbo=";
  };
}
