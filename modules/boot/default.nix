{
  lib,
  configuration,
  pkgs,
  ...
}: {
  imports = [
    ./binfmt.nix
    ./bootspec.nix
    ./crashDump.nix
    ./initrd
    ./iscsi-initiator.nix
    ./kernel.nix
    ./loader
    ./modprobeConfig.nix
    ./plymouth.nix
    ./swraid.nix
    ./tmp
    ./uki.nix
    ./zfs.nix
  ];
  boot = {
    bcache.enable = true;
    bcachefs.package = pkgs.bcachefs-tools;
    blacklistedKernelModules = {};
    consoleLogLevel = 0;
    devShmSize = "50%";
    devSize = "5%";
    enableContainers = false;
    extraModprobeConfig = "";
    extraModulePackages = [];
    extraSystemdUnitPaths = [];
    growPartition = false;
    hardwareScan = true;
    kernelModules =
      ["tcp_bbr"]
      ++ lib.optionals (configuration.hardware "cpuAmd") ["kvm_amd"]
      ++ lib.optionals (configuration.hardware "cpuIntel") ["kvm_intel"];
    kernelPackages = pkgs.linuxPackages_zen;
    kernelPatches = [];
    kernelParams =
      [
        "lsm=landlock,lockdown,yama,apparmor,bpf"
        "lockdown=confidentiality"
        "loglevel=7"
        "page_alloc.shuffle=1"
        "pci=pcie_bus_perf"
        "preempt=full"
        "random.trust_cpu=on"
        "slub_debug=FZP"
      ]
      ++ lib.optionals (configuration.branch != "developer") [
        "quiet"
        "rd.systemd.show_status=false"
        "splash"
      ]
      ++ lib.optionals (configuration.hardware "cpuAmd") ["amd_pstate=active"]
      ++ lib.optionals (configuration.hardware "gpuAmd") ["amdgpu.ppfeaturemask=0xffffffff"]
      ++ lib.optionals (configuration.hardware "gpuNvidia") [
        "nvidia_drm.modeset=1"
        #      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        #      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
      ];
    nixStoreMountOpts = [
      "ro"
      "nodev"
      "nouuid"
    ];
    postBootCommands = "";
    resumeDevice = "";
    runSize = "25%";
    supportedFilesystems = ["btrfs" "exfat" "ext4" "ntfs" "vfat"];
    systemdExecutable = "/run/current-system/systemd/lib/systemd/systemd";
  };
}
