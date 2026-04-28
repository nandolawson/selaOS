{ configuration, ... }:
{
    boot.loader.efi = {
        canTouchEfiVariables = {
            developer = true;
            insider = false;
            release = false;
        }.${configuration.General.channel} or false;
        efiSysMountPoint = "/boot";
    };
};