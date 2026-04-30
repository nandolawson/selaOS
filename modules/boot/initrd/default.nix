{ config, configuration, pkgs, ... }:
{
    imports = [
      ./clevis.nix
      ./luks.nix
      ./network
      ./services
      ./systemd
    ];
    boot.initrd = {
      allowMissingModules = false;
      availableKernelModules = [ "xhci_pci" "usbhid" ]
        ++ (
          if configuration.hardware "storageNvme"
          then [ "nvme" ]
          else []
        )
        ++ (
          if configuration.hardware "storageSata"
          then [ "ahci" "sd_mod" ]
          else []
        );
      checkJournalingFS = true;
      compressor = "zstd";
      compressorArgs = null;
      enable = !config.boot.isContainer;
      extraFiles = { };
      extraFirmwarePaths = [ ];
      includeDefaultModules = true;
      kernelModules = [  ];
      nix-store-veritysetup.enable = false;
      postMountCommands = "";
      postResumeCommands = "";
      preDeviceCommands = "";
      preFailCommands = "";
      preLVMCommands = "";
      prepend = [ ];
      secrets = { };
      supportedFilesystems = [ "btrfs" "vfat" ];
      verbose = (configuration.branch == "developer");
    };
}