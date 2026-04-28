{ configuraton, ... }:
{
    boot.loader.systemd-boot.netbootxyz = {
        enable = {
            developer = true;
            insider = false;
            release = false;
        }.${configuration.General.channel} or false;
        sortKey = "o_netbootxyz";
    };
}