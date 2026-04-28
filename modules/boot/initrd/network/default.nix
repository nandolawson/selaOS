{ config, ... }:
{
    imports = [
      ./ifstate.nix
      ./openvpn.nix
      ./ssh.nix
      ./udhcpc.nix
    ];
    boot.initrd.network = {
        enable = false;
        flushBeforeStage2 = !config.boot.initrd.systemd.enable;
        postCommands = "";
      };
}