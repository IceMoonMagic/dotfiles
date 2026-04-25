{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "codebook"
      "dockerfile"
      "git_firefly"
      "html"
      "nix"
      "typos"
    ];
    extraPackages = with pkgs; [
      nil
      # nixd
      package-version-server
      typos-lsp
    ];
    userSettings = {
      autosave = "on_focus_change";
      disable_ai = true;
      buffer_font_size = 16;
      buffer_font_family = "Noto Sans Mono";
      drag_and_drop_selection.delay = 0;
      terminal.cursor_shape = "bar";
      terminal.font_family = "NotoSansM Nerd Font";
      collaboration_panel.button = false;
      search.button = false;
      title_bar.show_sign_in = false;
      languages.nix.language_servers = [
        "nil"
        # "nixd"
      ];
    };
    userKeymaps = [
      {
        context = "Terminal";
        bindings.ctrl-s = [
          "terminal::SendKeystroke"
          "ctrl-s"
        ];
      }
    ];
  };

  # https://github.com/zed-industries/zed/issues/18982
  home.activation.zed-editor =
    let
      # Same as /etc/nixos/system/modules/defaults/packages.nix
      font-pkg = (
        pkgs.nerd-fonts.noto.overrideAttrs {
          preInstall = "find -not -name NotoSansMNerdFont-Regular.ttf -delete";
        }
      );
    in
    lib.mkIf config.programs.zed-editor.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        src='${font-pkg}/share/'
        dataHome='${config.xdg.dataHome}/'
        path='fonts/truetype/NerdFonts/Noto/NotoSansMNerdFont-Regular.ttf'
        if [ ! -e "$dataHome/$path" ]; then
          run install $VERBOSE_ARG -D "$src/$path" "$dataHome/$path"
        fi
      ''
    );
}
