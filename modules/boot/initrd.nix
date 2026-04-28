{ config, pkgs, ... }:
{
    boot.initrd = {
      allowMissingModules = false;
      availableKernelModules = [ "xhci_pci" "usbhid" ]
      ++ (if hardware "storageNvme" then [ "nvme" ] else [])
      ++ (if hardware "storageSata" then [ "ahci" "sd_mod" ] else []);
      checkJournalingFS = true;
      clevis = {
        devices = { };
        enable = false;
        package = pkgs.clevis;
        useTang = false;
      };
      compressor = "zstd";
      compressorArgs = null;
      enable = !config.boot.isContainer;
      extraFiles = { };
      extraFirmwarePaths = [ ];
      includeDefaultModules = true;
      kernelModules = [  ];
      luks = {
        cryptoModules = [ ];
        devices = { };
        fido2Support = false;
        gpgSupport = false;
        mitigateDMAAttacks = true;
        reusePassphrases = true;
        yubikeySupport = false;
      };
      network = {
        enable = false;
        flushBeforeStage2 = !config.boot.initrd.systemd.enable;
        ifstate = {
          allowIfstateToDrasticlyIncreaseInitrdSize = false;
          cleanupSettings = { interfaces = { }; };
          enable = false;
          package = pkgs.ifstate.override { withConfigValidation = false; };
          settings = { };
        };
        openvpn = {
          configuration = "";
          enable = false;
        };
        postCommands = "";
        ssh = {
          authorizedKeyFiles = [ ];
          enable = false;
          extraConfig = "";
          hostKeys = [ ];
          ignoreEmptyHostKeys = false;
          port = 22;
          shell = "\"/bin/ash\"";
        };
        udhcpc = {
          enable = config.networking.useDHCP;
          extraArgs = [ ];
        };
      };
      nix-store-veritysetup.enable = false;
      postMountCommands = "";
      postResumeCommands = "";
      preDeviceCommands = "";
      preFailCommands = "";
      preLVMCommands = "";
      prepend = [ ];
      secrets = { };
      services = {
        bcache.enable = config.boot.initrd.systemd.enable && config.boot.bcache.enable;
        lvm.enable = config.boot.initrd.systemd.enable && config.services.lvm.enable;
        resolved.enable = config.boot.initrd.systemd.network.enable;
        udev = {
          binPackages = [ ];
          packages = [ ];
          rules = "";
        };
      };
      supportedFilesystems = [ "btrfs" "vfat" ];
      systemd = {
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
      verbose = false;
    };
}