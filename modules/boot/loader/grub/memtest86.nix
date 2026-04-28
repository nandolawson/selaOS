{ configuration, ... }:
{
    boot.loader.grub.memtest86 = {
        enable = {
            developer = true;
            insider = false;
            release = false;
        }.${configuration.General.channel} or false;
        params = [ ];
    };
}