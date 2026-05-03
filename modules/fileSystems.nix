{name, ...}:
assert builtins.getEnv "EFI_UUID" != "" || throw "EFI_UUID fehlt!"; {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = ["subvol=@root" "compress=zstd" "noatime"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/${builtins.getEnv "EFI_UUID"}";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
    "/home" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd" "noatime"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = ["subvol=@nix" "compress=zstd" "noatime"];
    };
    "/var" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = ["subvol=@var" "compress=zstd" "noatime"];
    };
    "/var/log" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = ["subvol=@logs" "compress=zstd" "noatime"];
    };
    "/swap" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = ["subvol=@swap" "noatime"];
    };
  };
}
