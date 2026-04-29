{ branch, ... }:
{
    boot.loader.systemd-boot.netbootxyz = {
        enable = (branch == "developer");
        sortKey = "o_netbootxyz";
    };
}