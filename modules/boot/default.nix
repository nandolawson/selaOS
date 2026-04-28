{
  config,
  configuration,
  lib,
  hardware,
  name,
  pkgs,
  self,
  version,
  ...
}:
{
  boot = {
    bcache.enable = true;
    bcachefs.package = pkgs.bcachefs-tools;
    binfmt = {
      addEmulatedSystemsToNixSandbox = false;
      emulatedSystems = [ ];
      preferStaticEmulators = false;
      registrations = { };
    };
    blacklistedKernelModules = { };
    bootspec = {
      enableValidation = false;
      extensions = { };
      package = pkgs.bootspec;
    };
    consoleLogLevel = 0;
    crashDump = {
      enable = false;
      kernelParams = [
        "1"
        "boot.shell_on_fail"
      ];
      reservedMemory = "128M";
    };
    devShmSize = "50%";
    devSize = "5%";
    enableContainers = false;
    extraModprobeConfig = "";
    extraModulePackages = [ ];
    extraSystemdUnitPaths = [ ];
    growPartition = false;
    hardwareScan = true;
    initrd = {
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
    iscsi-initiator = {
      discoverPortal = null;
      extraConfig = null;
      extraConfigFile = null;
      extraIscsiCommands = "";
      logLevel = 1;
      loginAll = false;
      name = null;
      target = null;
    };
    kernel = {
      enable = true;
      randstructSeed = "";
      sysctl = {
        "kernel.sched_autogroup_enabled" = 0;
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "fq";
        "net.core.mem_max" = null;
        "net.core.wmem_max" = null;
        "vm.dirty_background_ratio" = 5;
        "vm.dirty_ratio" = 10;
        "vm.swappiness" = 180;
        "vm.vfs_cache_pressure" = 50;
      };
      sysfs = { };
    };
    kernelModules = [ "tcp_bbr" ]
    ++ lib.optionals (hardware "cpuAmd") [ "kvm_amd" ]
    ++ lib.optionals (hardware "cpuIntel") [ "kvm_intel" ];
    kernelPackages = pkgs.linuxPackages_zen;
    kernelPatches = [ ];
    kernelParams = [
      "lsm=landlock,lockdown,yama,apparmor,bpf"
      "lockdown=confidentiality"
      "page_alloc.shuffle=1"
      "slub_debug=FZP"
      "pci=pcie_bus_perf"
      "preempt=full"
      "quiet"
      "random.trust_cpu=on"
      "rd.systemd.show_status=false"
      "splash"
    ]
    ++ lib.optionals (hardware "gpuAmd") [ "amdgpu.ppfeaturemask=0xffffffff" ]
    ++ lib.optionals (hardware "gpuNvidia") [ "nvidia_drm.modeset=1" ];
    loader = {
      efi = {
        canTouchEfiVariables = {
          developer = true;
          insider = false;
          release = false;
        }.${configuration.General.channel} or false;
        efiSysMountPoint = "/boot";
      };
      external = {
        enable = false;
        installHook = "";
      };
      generationsDir = {
       copyKernels = true;
       enable = false;
      };
      generic-extlinux-compatible = {
        configurationLimit = 2;
        enable = false;
        mirroredBoots = [{ path = "/boot"; }];
        populateCmd = "";
        useGenerationDeviceTree = true;
      };
      grub = {
        backgroundColor = null;
        configurationLimit = 2;
        configurationName = "${name} ${version}";
        copyKernels = true;
        default = 0;
        device = "";
        devices = [ ];
        efiInstallAsRemovable = false;
        efiSupport = true;
        enable = false;
        enableCryptodisk = false;
        entryOptions = "--class nixos --unrestricted";
        extraConfig = "";
        extraEntries = "";
        extraEntriesBeforeNixOS = false;
        extraFiles = { };
        extraGrubInstallArgs = [ ];
        extraInstallCommands = "";
        extraPerEntryConfig = "";
        extraPrepareConfig = "";
        font = null;
        fontSize = null;
        forceInstall = false;
        forcei686 = false;
        fsIdentifier = "label";
        gfxmodeBios = "auto";
        gfxmodeEfi = "auto";
        gfxpayloadBios = "keep";
        gfxpayloadEfi = "keep";
        ipxe = { };
        memtest86 = {
          enable = {
            developer = true;
            insider = false;
            release = false;
          }.${configuration.General.channel} or false;
          params = [ ];
        };
        mirroredBoots = [ ];
        splashImage = null;
        splashMode = "stretch";
        storePath = "/nix/store";
        subEntryOptions = "--class nixos";
        theme = null;
        timeoutStyle = "hidden";
        useOSProber = false;
        users = { };
        zfsSupport = true;
      };
      limine = {
        additionalFiles = { };
        biosDevice = "nodev";
        efiInstallAsRemovable = false;
        efiSupport = true;
        enable = false;
        enableEditor = {
          developer = true;
          insider = false;
          release = false;
        }.${configuration.General.channel} or false;
        enrollConfig = true;
        extraConfig = "";
        extraEntries = "";
        force = false;
        maxGenerations = 2;
        package = pkgs.limine;
        panicOnChecksumMismatch = true;
        partitionIndex = null;
        secureBoot = {
          enable = false;
          sbctl = pkgs.sbctl;
        };
        style = {
          backdrop = null;
          graphicalTerminal = {
            background = null;
            brightBackground = null;
            brightForeground = null;
            brightPalette = null;
            font = {
              scale = null;
              spacing = null;
            };
            foreground = null;
            margin = null;
            marginGradient = null;
            palette = null;
          };
          interface = {
            branding = null;
            brandingColor = null;
            helpHidden = false;
            resolution = null;
          };
          wallpaperStyle = "stretched";
          wallpapers = [ ];
        };
        validateChecksums = true;
      };
      refind = {
        additionalFiles = { };
        efiInstallAsRemovable = false;
        enable = false;
        extraConfig = "";
        maxGenerations = 2;
        package = pkgs.refind;
      };
      systemd-boot = {
        configurationLimit = 2;
        consoleMode = "max";
        editor = {
          developer = true;
          insider = false;
          release = false;
        }.${configuration.General.channel} or false;
        edk2-uefi-shell = {
          enable = false;
          sortKey = "o_edk2-uefi-shell";
        };
        enable = true;
        extraEntries = { };
        extraFiles = { };
        extraInstallCommands = "";
        graceful = false;
        #installDeviceTree = "with config.hardware.deviceTree; enable && name != null";
        memtest86 = {
          enable = {
            developer = true;
            insider = false;
            release = false;
          }.${configuration.General.channel} or false;
          sortKey = "o_memtest86";
        };
        netbootxyz = {
          enable = {
            developer = true;
            insider = false;
            release = false;
          }.${configuration.General.channel} or false;
          sortKey = "o_netbootxyz";
        };
        rebootForBitlocker = false;
        sortKey = "${name}";
        windows = { };
        xbootldrMountPoint = null;
      };
      timeout = {
        developer = null;
        insider = 0;
        release = 0;
      }.${configuration.General.channel} or 0;
    };
    modprobeConfig = {
      enable = true;
      useUbuntuModuleBlacklist = true;
    };
    nixStoreMountOpts = [
      "ro"
      "nodev"
      "nouuid"
    ];
    plymouth = {
      enable = {
        developer = false;
        insider = true;
        release = true;
      }.${configuration.General.channel} or true;
      extraConfig = "";
      font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
      logo = "${self}/assets/logo.svg";
      package = pkgs.plymouth.override { systemd = config.boot.initrd.systemd.package; };
      #themePackages =
      theme = "bgrt";
      tpm2-totp = {
        enable = false;
        package = pkgs.tpm2-totp-with-plymouth;
      };
    };
    postBootCommands = "";
    resumeDevice = "";
    runSize = "25%";
    supportedFilesystems = [ "btrfs" "exfat" "ext4" "ntfs" "vfat" ];
    swraid = {
      enable = false;
      mdadmConf = "";
    };
    systemdExecutable = "/run/current-system/systemd/lib/systemd/systemd";
    tmp = {
      cleanOnBoot = false;
      tmpfsHugeMemoryPages = "never";
      tmpfsSize = "50%";
      useTmpfs = false;
      useZram = false;
      zramSettings = {
        compression-algorithm = "zstd";
        fs-type = "ext4";
        options = "X-mount.mode=1777,discard";
        zram-size = "ram * 0.5";
      };
    };
    uki = {
      #configFile
      #name
      #settings
      tries = null;
      version = config.system.image.version;
    };
    uvesafb = {
      enable = false;
      gfx-mode = "1024x768-32";
      v86d.package = ''
        config.boot.kernelPackages.v86d.overrideAttrs (old: {
            hardeningDisable = [ "all" ];
        })'';
    };
    zfs = {
      allowHibernation = false;
      devNodes = "/dev/disk/by-id";
      extraPools = [ ];
      forceImportAll = false;
      forceImportRoot = true;
      package = pkgs.zfs;
      passwordTimeout = 0;
      pools = {};
      removeLinuxDRM = false;
      requestEncryptionCredentials = true;
      useKeyringForCredentials = false;
    };

  };
}