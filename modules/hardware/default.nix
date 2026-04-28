{
  config,
  lib,
  hardware,
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
}