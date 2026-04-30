{
  config,
  lib,
  configuration,
  pkgs,
  ...
}:
{
  imports =
    [
      ./bluetooth.nix
      ./cpu.nix
      ./graphics.nix
    ];
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = config.hardware.enableAllFirmware;
    nvidia = lib.mkIf (configuration.hardware "gpuNvidia") {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
    };
    nvidia.NVreg_PreserveVideoMemoryAllocations=1;
    nvidia.NVreg_TemporaryFilePath=/var/tmp:;
  };
}