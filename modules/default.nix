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
      ./documentation
      ./hardware
      ./fileSystems.nix
      ./i18n
      ./networking.nix
      ./services
      ./system
      ./time.nix
      ./zramSwap.nix
    ];
  console.keyMap = "de";
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
  users.mutableUsers = true;
  xdg.portal.enable = true;
  programs.bash.completion.enable = true;
}
