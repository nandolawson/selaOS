{
  configuration,
  pkgs,
  ...
}:

assert (configuration.hardware "cpuIntel" || configuration.hardware "cpuAmd") || throw "CPU-Erkennung fehlgeschlagen!";
assert (configuration.hardware "gpuAmd" || configuration.hardware "gpuIntel" || configuration.hardware "gpuNvidia") || throw "GPU-Erkennung fehlgeschlagen!";
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
      ./systemd.nix
      ./time.nix
      ./users.nix
      ./zramSwap.nix
    ];
  console.keyMap = "de";
  nix = {
    settings = {
      auto-optimise-store = true;
      keep-outputs = false;
      keep-derivations = false;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  security.rtkit.enable = true;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8192;
    }
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.common.default = "kde";
  };
  programs.bash.completion.enable = true;
}
