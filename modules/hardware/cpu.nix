{ config, lib, configuration, ... }:

{
    hardware.cpu = {
        amd = lib.mkIf (configuration.hardware "cpuAmd") {
            updateMicrocode = config.hardware.enableRedistributableFirmware;
        };
        intel = lib.mkIf (configuration.hardware "cpuIntel") {
            npu.enable = false;
            updateMicrocode = config.hardware.enableRedistributableFirmware;
        };
    };
}