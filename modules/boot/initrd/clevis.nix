{ ... }:
{
    boot.initrd.clevis = {
        devices = { };
        enable = false;
        package = pkgs.clevis;
        useTang = false;
    };
}