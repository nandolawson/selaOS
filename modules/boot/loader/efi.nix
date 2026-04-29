{ branch, ... }:
{
    boot.loader.efi = {
        canTouchEfiVariables = (branch == "developer");
        efiSysMountPoint = "/boot";
    };
}