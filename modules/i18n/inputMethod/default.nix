{...}: {
  imports = [
    ./fcitx5
    ./ibus.nix
    ./kime.nix
  ];
  i18n.inputMethod = {
    enable = true;
    enableGtk2 = false;
    enableGtk3 = true;
    type = "fcitx5";
    uim.toolbar = "gtk";
  };
}
