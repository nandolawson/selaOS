{ configuration, ... }:
{
    boot.loader.systemd-boot.netbootxyz = {
        enable = (configuration.branch == "developer");
        sortKey = "o_netbootxyz";
    };
}