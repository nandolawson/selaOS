{ ... }:
{
    imports = [
        ./zramSettings.nix
    ];
    boot.tmp = {
        cleanOnBoot = false;
        tmpfsHugeMemoryPages = "never";
        tmpfsSize = "50%";
        useTmpfs = false;
        useZram = false;
    };
}