{configuration, ...}: {
  boot.loader.efi = {
    canTouchEfiVariables = configuration.branch == "developer";
    efiSysMountPoint = "/boot";
  };
}
