{ hardware, lib, pkgs, ... }:
{
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = lib.mkIf (hardware "gpuAmd") (
            with pkgs; [
                amdvlk
                rocmPackages.clr.icd
            ]
        );
    };  
}