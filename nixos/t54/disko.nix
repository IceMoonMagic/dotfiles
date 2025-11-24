{
  # https://github.com/nix-community/disko/blob/master/example/btrfs-subvolumes.nix
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB256HBHQ-000L7_S4ELNF1N130138";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1MiB";
              end = "1GiB";
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
                      mountpoint = "/var/log";
                    };
                    "@games" = { inherit mountOptions; };
                    "@games/saves" = { inherit mountOptions; };
                  };
                  inherit mountOptions;
                  mountpoint = "/mnt/nvme0n1p3";
                };
              };
            swap = {
              size = "16G";
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
