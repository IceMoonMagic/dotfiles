{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "codebook"
      "dockerfile"
      "git_firefly"
      "html"
      "nix"
    ];
    extraPackages = with pkgs; [
      nil
      nixd
    ];
    userSettings = {
      autosave = "on_focus_change";
      disable_ai = true;
      buffer_font_size = 16;
      # https://github.com/zed-industries/zed/issues/18982
      # buffer_font_family = "NotoSansM Nerd Font";
      buffer_font_family = "Noto Sans Mono";
      drag_and_drop_selection.delay = 0;
      terminal.cursor_shape = "bar";
      collaboration_panel.button = false;
      search.button = false;
      title_bar.show_sign_in = false;
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
}
