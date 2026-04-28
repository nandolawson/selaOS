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
  imports =
    [
      ./binfmt.nix
      ./initrd.nix
      ./iscsi-initiator.nix
      ./kernel.nix
      ./plymouth.nix
    ]
  boot = {
    bcache.enable = true;
    bcachefs.package = pkgs.bcachefs-tools;
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