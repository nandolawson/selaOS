{ config, ... }:
{
        boot.initrd.network.udhcpc = {
          enable = config.networking.useDHCP;
          extraArgs = [ ];
        };
}