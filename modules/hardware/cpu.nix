{ lib, hardware, ... }:

{
    hardware.cpu = {
        amd = lib.mkIf (hardware "cpuAmd") {
            updateMicrocode = config.hardware.enableRedistributableFirmware;
        };
        intel = lib.mkIf (hardware "cpuIntel") {
            npu.enable = false;
            updateMicrocode = config.hardware.enableRedistributableFirmware;
        };
    };
}