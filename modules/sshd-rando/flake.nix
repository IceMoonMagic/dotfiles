{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.sshd-rando = {
    flake = false;
    url = "github:mint-choc-chip-skyblade/sshd-rando?rev=5e54c83754112c28c69369183fba06cf3f9abe88";
  };
  inputs.pyqtdarktheme = {
    flake = false;
    url = "github:CovenEsme/PyQtDarkTheme";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        # Darwins' python3.12-pyclip-0.7.0 is marked as broken
        # "x86_64-darwin"
        # "aarch64-darwin"
      ];
      systemPkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = systemPkgs.${system};
        in
        rec {
          default = sshd-rando;
          sshd-rando = pkgs.python312Packages.buildPythonApplication rec {
            pname = "sshd-rando";
            version = "2.2";
            src = inputs.sshd-rando;
            format = "none";
            nativeBuildInputs =
              with pkgs.python312Packages;
              [
                cmake
                #nlzss11
                pyyaml
                lz4
                pyside6
                (pyqtdarktheme.overrideAttrs {
                  version = "2.2.0";
                  src = inputs.pyqtdarktheme;
                })
                typing-extensions
                pyclip
                black
                pytest
                pytest-xdist
                pyinstaller
                pillow
                platformdirs
              ]
              ++ (with pkgs; [
                libxcb-cursor
              ])
              # /*
              ++ (with pkgs.libsForQt5.qt5; [
                qtbase
                wrapQtAppsHook
              ])
              /*
                /
                ++ (with pkgs.kdePackages; [
                  qtbase
                  wrapQtAppsHook
                  wrapQtAppsNoGuiHook
                ])
                #
              */
              ++ [
                nlzss11
              ];
            dontUseCmakeConfigure = true;

            buildPhase = ''
              python3 -m PyInstaller --log-level=WARN sshdrando.spec
            '';
            installPhase = ''
              install -Dm755 "./dist/Skyward Sword HD Randomizer ${version}" $out/bin/sshd-rando
            '';
          };
          nlzss11 = pkgs.python312Packages.buildPythonPackage rec {
            pname = "nlzss11";
            version = "1.8";
            pyproject = true;
            src = pkgs.fetchPypi {
              inherit pname version;
              sha256 = "03710ab4330b25ab2ca8a44bd7fabd1b9d93ba25830f1c404a77c8e3eca1d382";
            };
            nativeBuildInputs =
              with pkgs;
              [
                cmake
                gcc
                zlib-ng
              ]
              ++ (with pkgs.python312Packages; [
                pybind11
                wheel
                setuptools
              ]);
            dontUseCmakeConfigure = true;
            preConfigure = ''
              export CMAKE_POLICY_VERSION_MINIMUM=3.5
            '';
            buildPhase = ''
              python3 setup.py bdist_wheel
            '';
          };
        }
      );
    };
}
