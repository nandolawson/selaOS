{ branch, ... }:
{
    boot.loader.systemd-boot.memtest86 = {
        enable = (branch == "developer");
        sortKey = "o_memtest86";
    };
}