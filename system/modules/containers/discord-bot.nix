{
  config,
  lib,
  ...
}:

let
  cfg = config.virtualisation.quadlets.discord-bot;
in
with lib;
{
  options.virtualisation.quadlets.discord-bot = {
    enable = mkEnableOption "Discord Bot";
    configDir = mkOption {
      description = "The config directory, where your `configuration.yaml` is located";
      type = types.str;
      default = "/var/lib/discord-bot";
    };
    uid = mkOption {
      description = "UID to use inside the container";
      type = types.int;
      default = 1000;
    };
    gid = mkOption {
      description = "UID to use inside the container";
      type = types.int;
      default = 1000;
    };
  };
  config = {
    environment.etc = optionalAttrs cfg.enable {
      "containers/systemd/discord-bot.container".text = ''
        [Unit]
        Description=Discord Bot - My Personal Bot for Discord
        Documentation=https://github.com/IceMoonMagic/DiscordVCLogger
        Requires=network-online.target
        After=network-online.target

        [Container]
        ContainerName=discord-bot
        Image=discord-bot.build
        Volume=${cfg.configDir}:/DiscordVCLogger-master/saves

        [Service]
        Slice=quadlets.slice
        Restart=always

        [Install]
        WantedBy=quadlets.target
      '';
      "containers/systemd/discord-bot.build".text =
        let
          uid = builtins.toString cfg.uid;
          gid = builtins.toString cfg.gid;
          dockerfile = builtins.toFile "discord-bot-Dockerfile" ''
            FROM docker.io/library/python:3.12-alpine

            USER $UID:$GID

            # RUN git clone https://github.com/IceMoonMagic/DiscordVCLogger.git discord-bot
            RUN wget -qO- https://github.com/IceMoonMagic/DiscordVCLogger/archive/refs/heads/master.tar.gz \
                | tar -vxz
            WORKDIR DiscordVCLogger-master
            VOLUME saves

            RUN pip install --no-cache-dir -r requirements.txt

            CMD [ "python", "./discord_bot.py" ]
          '';
        in
        ''
          [Build]
          File=${dockerfile}
          Pull=newer
          ImageTag=discord-bot
          PodmanArgs=--build-arg 'UID=${uid}' --build-arg 'GID=${gid}'
        '';
    };
  };
}
