{
  config,
  lib,
  hardware,
  pkgs,
  ...
}:
{
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
}