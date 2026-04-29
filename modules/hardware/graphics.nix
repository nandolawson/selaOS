{ configuration, lib, pkgs, ... }:
{
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = lib.mkIf (configuration.hardware "gpuAmd") (
            with pkgs; [
                amdvlk
                rocmPackages.clr.icd
            ]
        );
    };  
}