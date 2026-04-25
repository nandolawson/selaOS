{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    sweet
    kdePackages.icons-in-terminal
    kdePackages.qtstyleplugin-kvantum
  ];
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "kvantum";
};
}