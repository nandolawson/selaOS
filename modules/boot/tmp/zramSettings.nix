{ ... }:
{
    boot.tmp.zramSettings = {
        compression-algorithm = "zstd";
        fs-type = "ext4";
        options = "X-mount.mode=1777,discard";
        zram-size = "ram * 0.5";
    };
}