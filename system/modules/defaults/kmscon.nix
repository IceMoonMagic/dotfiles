{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "NotoSansM Nerd Font";
        package = (
          pkgs.nerd-fonts.noto.overrideAttrs {
            preInstall = "find -not -name NotoSansMNerdFont-Regular.ttf -delete";
          }
        );
      }
    ];
  };
}
