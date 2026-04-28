{ ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    #useDHCP = true;
  };
}