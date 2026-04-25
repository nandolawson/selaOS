{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    sweet
    kdePackages.qtstyleplugin-kvantum
  ];
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "kvantum";
};
}