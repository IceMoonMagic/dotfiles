{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      forAllSystems = with nixpkgs.lib; genAttrs systems.flakeExposed;
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
            src = builtins.fetchGit {
              url = "https://github.com/mint-choc-chip-skyblade/sshd-rando";
              rev = "5e54c83754112c28c69369183fba06cf3f9abe88";
            };
            format = "none";
            nativeBuildInputs =
              with pkgs.python312Packages;
              [
                cmake
                #nlzss11
                pyyaml
                lz4
                pyside6
                #pyqtdarktheme
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
                pyqtdarktheme
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
          pyqtdarktheme = pkgs.python312Packages.buildPythonPackage rec {
            pname = "PyQtDarkTheme";
            version = "2.2.0";
            pyproject = true;
            nativeBuildInputs = with pkgs.python312Packages; [
              poetry-core
            ];
            propagatedBuildInputs = with pkgs.python312Packages; [
              darkdetect
            ];
            src = fetchGit {
              url = "https://github.com/CovenEsme/PyQtDarkTheme";
              rev = "ab4b136680ca6ab9098c548ee35c2a983fe869fc";
            };
            postPatch = ''
              sed -i 's/^darkdetect = "^0\.7\.1"/darkdetect = "^0.8.0"/' pyproject.toml
            '';
          };
        }
      );
    };
}
