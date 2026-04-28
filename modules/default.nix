{
  config,
  configuration,
  lib,
  hardware,
  name,
  pkgs,
  self,
  version,
  ...
}:

assert builtins.getEnv "EFI_UUID" != "" || throw "EFI_UUID fehlt!";
assert (hardware "cpuIntel" || hardware "cpuAmd") || throw "CPU-Erkennung fehlgeschlagen!";
assert (hardware "gpuAmd" || hardware "gpuIntel" || hardware "gpuNvidia") || throw "GPU-Erkennung fehlgeschlagen!";
{
  imports =
    [
      ./boot
      ./hardware.nix
      ./filesystems.nix
      ./services.nix
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
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  security.rtkit.enable = true;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8192;
    }
  ];
  system = {
    nixos = {
      distroName = name;
      distroId = lib.toLower name;
      label = "${name}-${version}";
      versionSuffix = " Test";
      version = version;
    };
  };
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
  xdg.portal = {
    enable = true;
  };
  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 50;
    priority = 100;
  };
  i18n.defaultLocale = "de_DE.UTF-8";
}
