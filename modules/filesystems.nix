{ name, self, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@root" "compress=zstd" "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/${builtins.getEnv "EFI_UUID"}";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    "/home" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };
    "/var/lib/flatpak" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@flatpak" "compress=zstd" "noatime" ];
    };
    "/var/log" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@logs" "compress=zstd" "noatime" ];
    };
    "/swap" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@swap" "noatime" ];
    };
  };
}