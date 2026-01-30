{ config, pkgs, ... }:

{
  programs.vesktop = {
    enable = true;
    settings = {
      minimizeToTray = "on";
      discordBranch = "stable";
      staticTitle = true;
      appBadge = false;
      customTitleBar = false;
    };
    vencord.settings = {
      autoUpdate = true;
      autoUpdateNotification = false;
      plugins = {
        ImageZoom = {
          enabled = true;
          size = 600.2640845070422;
          zoom = 2.8000000000000034;
          nearestNeighbour = false;
          square = true;
          saveZoomValues = true;
          invertScroll = true;
          zoomSpeed = 0.5;
        };
        NoDevtoolsWarning = {
          enabled = true;
        };
        NoReplyMention = {
          enabled = true;
          userList = "1234567890123445;1234567890123445";
          shouldPingListed = true;
          inverseShiftReply = false;
        };
        OpenInApp = {
          enabled = true;
          spotify = true;
          steam = true;
          epic = true;
          tidal = true;
          itunes = true;
        };
        RoleColorEverywhere = {
          enabled = true;
          chatMentions = true;
          memberList = true;
          voiceUsers = true;
          reactorsList = true;
          pollResults = true;
          colorChatMessages = false;
        };

        TypingTweaks = {
          enabled = true;
          alternativeFormatting = true;
          showRoleColors = true;
          showAvatars = true;
        };
        VoiceChatDoubleClick = {
          enabled = true;
        };
        VolumeBooster = {
          enabled = true;
          multiplier = 2;
        };
      };
    };
  };
}
