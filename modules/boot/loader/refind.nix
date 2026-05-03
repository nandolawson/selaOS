{pkgs, ...}: {
  boot.loader.refind = {
    additionalFiles = {};
    efiInstallAsRemovable = false;
    enable = false;
    extraConfig = "";
    maxGenerations = 2;
    package = pkgs.refind;
  };
}
