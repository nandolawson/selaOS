{ configuration, ... }:
{
    boot.loader.systemd-boot.memtest86 = {
        enable = {
            developer = true;
            insider = false;
            release = false;
        }.${configuration.General.channel} or false;
        sortKey = "o_memtest86";
    };
}