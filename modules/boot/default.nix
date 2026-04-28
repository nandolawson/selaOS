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
      ./bootspec.nix
      ./crashDump.nix
      ./initrd.nix
      ./iscsi-initiator.nix
      ./kernel.nix
      ./loader
      ./plymouth.nix
      ./tmp.nix
      ./zfs.nix
    ];
  boot = {
    bcache.enable = true;
    bcachefs.package = pkgs.bcachefs-tools;
    blacklistedKernelModules = { };
    consoleLogLevel = 0;
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
  };
}