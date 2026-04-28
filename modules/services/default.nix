{ lib, pkgs, ... }:
{
  imports =
    [
      ./ananicy.nix
      ./flatpak.nix
      ./pipewire.nix
      ./xserver.nix
    ];
  services = {
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
      notoPackage = pkgs.noto-fonts;
    };
    displayManager.sddm = {
      autoLogin = {
        minimumUid = 1000;
        relogin = false;
      };
      autoNumlock = false;
      enable = true;
      enableHidpi = true;
      extraPackages = [ ];
      #package = pkgs.kdePackages.sddm;
      settings = { };
      setupScript = "";
      stopScript = "";
      #theme = "";
      wayland = {
        compositor = "kwin";
        enable = true;
      };
    };
    fwupd.enable = true;
  };
}