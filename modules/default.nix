{
  lib,
  hardware,
  name,
  pkgs,
  self,
  version,
  ...
}:

assert (hardware "cpuIntel" || hardware "cpuAmd") || throw "CPU-Erkennung fehlgeschlagen!";
assert (hardware "gpuAmd" || hardware "gpuIntel" || hardware "gpuNvidia") || throw "GPU-Erkennung fehlgeschlagen!";
{
  imports =
    [
      ./boot
      ./hardware
      ./fileSystems.nix
      ./networking.nix
      ./services
      ./system.nix
      ./zramSwap.nix
    ];
  console.keyMap = "de";
  documentation.nixos = {
      checkRedirects = true;
      enable = false;
      extraModules = [ ];
      extraModuleSources = [ ];
      includeAllModules = false;
      options = {
          splitBuild = true;
          warningsAreErrors = true;
      };
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  security.rtkit.enable = true;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8192;
    }
  ];
  systemd.tmpfiles.rules = [
    "d /var/lib/flatpak/user-data 0775 root users -"
    "L+ %h/.var - - - - /var/lib/flatpak/user-data/%u"
    "L+ /var/lib/flatpak/overrides/global - - - - socket=wayland,fallback-x11;device=dri;filesystems=home;"
  ];
  time = {
    hardwareClockInLocalTime = false;
    timeZone = "Europe/Berlin";
  };
  users.mutableUsers = true;
  xdg.portal.enable = true;
  i18n.defaultLocale = "de_DE.UTF-8";
}
