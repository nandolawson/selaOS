{ config, ... }:
{
  imports = [ ./udev.nix ];
      boot.initrd.services = {
        bcache.enable = config.boot.initrd.systemd.enable && config.boot.bcache.enable;
        lvm.enable = config.boot.initrd.systemd.enable && config.services.lvm.enable;
        resolved.enable = config.boot.initrd.systemd.network.enable;
      };
}