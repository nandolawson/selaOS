{ config, ... }:
{
      boot.initrd.systemd = {
        additionalUpstreamUnits = [ ];
        automounts = [ ];
        contents = { };
        dbus.enable = false;
        dmVerity.enable = false;
        emergencyAccess = false;
        enable = true;
        extraBin = { };
        fido2.enable = false;
        groups = { };
        initrdBin = [ ];
        managerEnvironment = { PATH = "/bin:/sbin"; };
        mounts = [ ];
        network = {
          config = { };
          enable = false;
          links = { };
          netdevs = { };
          networks = { };
          wait-online = {
            anyInterface = config.networking.useDHCP;
            enable = false;
            extraArgs = [ ];
            ignoredInterfaces = [ ];
            timeout = 120;
          };
        };
        package = config.systemd.package;
        packages = [ ];
        paths = { };
        repart = {
          device = null;
          discard = true;
          empty = "refuse";
          enable = false;
          extraArgs = [ ];
        };
        root = "fstab";
        services = { };
        slices = { };
        sockets = { };
        storePaths = [ ];
        suppressedStorePaths = [ ];
        suppressedUnits = [ ];
        targets = { };
        timers = { };
        tmpfiles = { };
        tpm2.enable = config.boot.initrd.systemd.package.withTpm2Units;
        units = { };
        users = { };
      };
}