{ pkgs, ... }:
{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    cloc
    compsize
    fastfetch
    tree
    rmlint
    nixfmt
    p7zip
    unrar
    #     unrar-free
    (nerd-fonts.noto.overrideAttrs {
      preInstall = "find -not -name NotoSansMNerdFont-Regular.ttf -delete";
    })
  ];
  programs.nano.nanorc = builtins.readFile ../../../home/shells/nanorc;
}
