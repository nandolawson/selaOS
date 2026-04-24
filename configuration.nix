{
  config,
  configuration,
  lib,
  name,
  pkgs,
  self,
  version,
  ...
}:
let
  hardware = flag: builtins.match ".*${flag}.*" (builtins.getEnv "HARDWARE") != null;
in
assert builtins.getEnv "EFI_UUID" != "" || throw "EFI_UUID fehlt!";
assert (hardware "cpuIntel" || hardware "cpuAmd") || throw "CPU-Erkennung fehlgeschlagen!";
assert (hardware "gpuAmd" || hardware "gpuIntel" || hardware "gpuNvidia") || throw "GPU-Erkennung fehlgeschlagen!";
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
  console.keyMap = "${configuration.General.keyboardLayout or "en"}";
  documentation.nixos = {
      checkRedirects = true;
      enable = false;
      extraModules = [ ];
      extraModuleSources = [ ];
      includeAllModules = false;
      options = {
          splitBuild = true;
          warningsAreErrors = true;
      };
  };
  environment = {
    etc."os-release".text = lib.mkForce ''
      ANSI_COLOR="0;34"
      ID="${lib.toLower name}"
      ID_LIKE="nixos"
      NAME="${name}"
      PRETTY_NAME="${name} ${version}"
    '';
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@root" "compress=zstd" "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/${builtins.getEnv "EFI_UUID"}";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    "/home" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };
    "/var/lib/flatpak" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@flatpak" "compress=zstd" "noatime" ];
    };
    "/var/log" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@logs" "compress=zstd" "noatime" ];
    };
    "/swap" = {
      device = "/dev/disk/by-label/${name}";
      fsType = "btrfs";
      options = [ "subvol=@swap" "noatime" ];
    };
  };
  hardware = {
    bluetooth = {
      disabledPlugins = [ ];
      enable = true;
      hsphfpd.enable = false;
      input = { };
      network = { };
      package = pkgs.bluez;
      powerOnBoot = true;
      settings = {
        General = {
          RememberPowered = true;
          FastConnectable = true;
        };
      };
    };
    cpu = {
      amd = lib.mkIf (hardware "cpuAmd") {
        updateMicrocode = config.hardware.enableRedistributableFirmware;
      };
      intel = lib.mkIf (hardware "cpuIntel") {
        npu.enable = false;
        updateMicrocode = config.hardware.enableRedistributableFirmware;
      };
    };
    enableAllFirmware = true;
    enableRedistributableFirmware = config.hardware.enableAllFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = lib.mkIf (hardware "gpuAmd") (with pkgs; [
        amdvlk
        rocmPackages.clr.icd
      ]);
    };
    nvidia = lib.mkIf (hardware "gpuNvidia") {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
    };
  };
  i18n.defaultLocale = "${configuration.General.language or "en_EN"}.UTF-8";
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  security.rtkit.enable = true;
  services = {
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
      notoPackage = pkgs.noto-fonts;
    };
    displayManager.sddm = {
      autoLogin = {
        minimumUid = 1000;
        relogin = false;
      };
      autoNumlock = false;
      enable = true;
      enableHidpi = true;
      extraPackages = [ ];
      #package = pkgs.kdePackages.sddm;
      settings = { };
      setupScript = "";
      stopScript = "";
      #theme = "";
      wayland = {
        compositor = "kwin";
        enable = true;
      };
    };
    flatpak = {
      enable = true;
      remotes = lib.mkDefault [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
    };
    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      enable = true;
      pulse.enable = true;
    };
    xserver = {
      videoDrivers =
        (lib.optionals (hardware "gpuAmd") [ "amdgpu" ])
        ++ (lib.optionals (hardware "gpuNvidia") [ "nvidia" ])
        ++ [ "modesetting" ];
      xkb = {
        layout = "en"
        variant = "";
      };
    };
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8192;
    }
  ];
  system.nixos = {
    distroName = "${name}";
    distroId = lib.toLower name;
    label = "${name}-v${version}";
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/flatpak/user-data 0775 root users -"
    "L+ %h/.var - - - - /var/lib/flatpak/user-data/%u"
    "L+ /var/lib/flatpak/overrides/global - - - - socket=wayland,fallback-x11;device=dri;filesystems=home;"
  ];
  time = {
    hardwareClockInLocalTime = false;
    timeZone = null;
  };
  users.mutableUsers = true;
  xdg.portal = {
    enable = true;
  };
  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };
}
