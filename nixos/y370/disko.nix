{
  # https://github.com/nix-community/disko/blob/master/example/btrfs-subvolumes.nix
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/by-id/<>";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root =
              let
                mountOptions = [
                  "compress-force=zstd"
                  "lazytime"
                ];
              in
              {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  subvolumes = {
                    "@" = {
                      inherit mountOptions;
                      mountpoint = "/";
                    };
                    "@home" = {
                      inherit mountOptions;
                      mountpoint = "/home";
                    };
                    "@nix" = {
                      inherit mountOptions;
                      mountpoint = "/nix";
                    };
                    "@cache" = {
                      inherit mountOptions;
                      mountpoint = "/var/cache";
                    };
                    "@log" = {
                      inherit mountOptions;
                      moutnpoint = "/var/log";
                    };
                  };
                  inherit mountOptions;
                  mountpoint = "/mnt";
                };
              };
          };
        };
      };
    };
    nodev."/tmp".fsType = "tmpfs";
  };
}
