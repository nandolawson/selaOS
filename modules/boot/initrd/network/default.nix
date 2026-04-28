{ ... }:
{
    boot.initrd.network = {
      imports = [
        ./ifstate.nix
        ./openvpn.nix
        ./ssh.nix
        ./udhcpc.nix
      ];
        enable = false;
        flushBeforeStage2 = !config.boot.initrd.systemd.enable;
        postCommands = "";
      };
}