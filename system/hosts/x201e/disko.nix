{
  # https://github.com/nix-community/disko/blob/master/example/btrfs-subvolumes.nix
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST320LT012-9WS14C_W0V1ZV5C";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1MiB";
              end = "512MiB";
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
                  "defaults"
                  "compress=zstd"
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
                      mountpoint = "/var/log";
                    };
                    "@var" = {
                      inherit mountOptions;
                      mountpoint = "/var";
                    };
                  };
                  inherit mountOptions;
                  mountpoint = "/mnt/sda3";
                };
              };
            swap = {
              size = "4G";
              content = {
                type = "swap";
                resumeDevice = true;
                discardPolicy = "both";
              };
            };
          };
        };
      };
    };
    nodev."/tmp".fsType = "tmpfs";
  };
}
