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
      ./nix
      ./services
      ./system
      ./systemd.nix
      ./time.nix
      ./users.nix
      ./zramSwap.nix
    ];
  console.keyMap = "de";
  security.rtkit.enable = true;
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 8192;
    }
  ];
  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "kde"
          "gtk"
        ];
      };
    };
  };
  environment.etc."flatpak/overrides/com.google.Chrome".text = ''
    [Context]
    filesystems=home;
    [Session Bus Policy]
    org.freedesktop.portal.Desktop=talk
    org.freedownloadmanager.Manager=talk
  '';
  environment.etc."flatpak/overrides/org.freedownloadmanager.Manager".text = ''
    [Context]
    filesystems=home;
    [Session Bus Policy]
    org.freedownloadmanager.Manager=own
  '';
  system.activationScripts.flatpak-overrides.text = ''
    mkdir -p /var/lib/flatpak/overrides
    for file in /etc/flatpak/overrides/*; do
      if [ -e "$file" ]; then
        ln -sf "$file" "/var/lib/flatpak/overrides/$(basename "$file")"
      fi
    done
  '';
  programs.bash.completion.enable = true;
}
