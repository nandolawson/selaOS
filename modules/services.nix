{ config, lib, pkgs, ... }:
{ 
  services = {
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
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
    flatpak = {
      enable = true;
      remotes = lib.mkDefault [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
    };
    fwupd.enable = true;
    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      enable = true;
      pulse.enable = true;
    };
    xserver = {
      exportConfiguration = true;
      videoDrivers =
        (lib.optionals (hardware "gpuAmd") [ "amdgpu" ])
        ++ (lib.optionals (hardware "gpuNvidia") [ "nvidia" ])
        ++ [ "modesetting" ];
      xkb = {
        layout = "de";
        variant = "";
      };
    };
  };
}