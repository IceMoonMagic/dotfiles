{ config, pkgs, ... }:

{
  home.sessionVariables.MANGOHUD = 1;
  programs.mangohud = {
    enable = true;
    # Setting in Nix so can override with simple `config.programs.mangohud.settings // {changes}`
    settings = {
      ### See `https://github.com/flightlessmango/MangoHud/blob/master/data/MangoHud.conf`
      ### Display the current system time
      time = true;
      time_format = "%H:%M";

      ### Display the current CPU information
      cpu_stats = true;
      cpu_temp = true;

      ### Display the current GPU information
      gpu_stats = true;
      gpu_temp = true;

      ### Display battery information
      # battery
      # battery_icon
      # gamepad_battery
      # gamepad_battery_icon

      ### Display FPS and frametime
      fps = true;

      ### Display GPU throttling status based on Power, current, temp or "other"
      ## Only shows if throttling is currently happening
      throttling_status = true;

      ### Remove margins around MangoHud
      hud_no_margin = true;

      ### Display compact version of MangoHud
      hud_compact = true;

      ### Display MangoHud in a horizontal position
      horizontal = true;

      ### Disable / hide the hud by default
      no_display = true;

      display_server = true;

      ### Color customization
      # text_color=FFFFFF
      # gpu_color=2E9762
      # cpu_color=2E97CB
      # vram_color=AD64C1
      # ram_color=C26693
      # engine_color=EB5B5B
      # io_color=A491D3
      # frametime_color=00FF00
      # background_color=020202
      # media_player_color=FFFFFF
      # wine_color=EB5B5B
      # battery_color=FF9078

      ### Change toggle keybinds for the hud & logging
      # toggle_hud=Shift_R+F12
      # toggle_hud_position=Shift_R+F11
      # toggle_fps_limit=Shift_L+F1
      # toggle_logging=Shift_L+F2
      # reload_cfg=Shift_L+F4
      # upload_log=Shift_L+F3
    };
  };
}
