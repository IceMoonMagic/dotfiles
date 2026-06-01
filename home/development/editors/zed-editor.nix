{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.shellAliases = lib.optionalAttrs config.programs.zed-editor.enable {
    zed = "zeditor --new";
    zeditor = "zeditor --new";
  };
  programs.zed-editor = {
    enable = lib.mkDefault true;
    extensions = [
      # Themes & Icons
      "godot-theme"
      "material-icon-theme"
      # Languages & Grammars
      "asciidoc"
      "dockerfile"
      "gdscript" # LSP from godot editor
      "html"
      "nix"
      # Etc
      "typos"
    ];
    extraPackages = with pkgs; [
      nil
      package-version-server
      typos-lsp
    ];
    userSettings = {
      # Behavior
      autosave = "on_focus_change";
      cli_default_open_behavior = "new_window"; # Kinda broken (github:zed-industries/zed#53528)
      completions.lsp_insert_mode = "insert";
      disable_ai = true;
      document_folding_ranges = "on";
      drag_and_drop_selection.delay = 0;
      extend_comment_on_newline = false;
      restore_on_startup = "empty_tab";
      # Layout
      collaboration_panel.button = false;
      search.button = false;
      title_bar.show_sign_in = false;
      # Themes
      theme = "Godot";
      icon_theme = "Material Icon Theme";
      # Buffer & Terminal
      buffer_font_family = "Noto Sans Mono";
      buffer_font_size = 16;
      terminal.button = false; # Use keybind for center term instead
      terminal.cursor_shape = "bar";
      terminal.font_family = "NotoSansM Nerd Font";
      wrap_guides = [
        80
        120
      ];
      # Languages
      languages.Nix.language_servers = [
        "nil"
        "typos"
      ];
    };
    userKeymaps = [
      {
        bindings.ctrl-shift-t = "workspace::NewCenterTerminal";
      }
      {
        context = "Terminal";
        bindings.ctrl-q = [
          "terminal::SendKeystroke"
          "ctrl-q"
        ];
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
