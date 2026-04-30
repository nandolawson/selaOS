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
      ./console.nix
      ./documentation
      ./environment
      ./hardware
      ./fileSystems.nix
      ./i18n
      ./networking.nix
      ./nix
      ./nixpkgs
      ./security
      ./services
      ./system
      ./systemd.nix
      ./time.nix
      ./users.nix
      ./xdg
      ./zramSwap.nix
    ];
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8192;
    }
  ];
}
