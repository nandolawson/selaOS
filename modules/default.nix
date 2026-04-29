{
  configuration,
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  security.rtkit.enable = true;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8192;
    }
  ];
  xdg.portal.enable = true;
  programs.bash.completion.enable = true;
}
