{ config, ... }:

{
  imports = [
    ./databases.nix
    ./go.nix
    ./python.nix
    ./typescript.nix
  ];
}
