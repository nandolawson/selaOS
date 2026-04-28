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