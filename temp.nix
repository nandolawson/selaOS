{ pkgs, lib, ... }:

let
  candy-icons = pkgs.stdenv.mkDerivation {
    pname = "candy-icons";
    version = "latest";
    src = pkgs.fetchFromGitHub {
      owner = "EliverLara";
      repo = "candy-icons";
      rev = "master";
      hash = "sha256-TzovzmfrUuaSrtpKCQxyXcih7cKSBhBtMpZLVwY/ScA=";
    };
    dontBuild = true;
    installPhase = "mkdir -p $out/share/icons/candy-icons && cp -r * $out/share/icons/candy-icons/";
  };

  whitesur-kde = pkgs.stdenv.mkDerivation {
    pname = "whitesur-kde";
    version = "latest";
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-kde";
      rev = "master";
      hash = "sha256-t0bCb1X6BprttUUEcfVqjLskulbFxwXQwUMBn6p8Ho8=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/Kvantum
      cp -r Kvantum/WhiteSur* $out/share/Kvantum/

      mkdir -p $out/share/plasma/desktoptheme
      cp -r Plasma/WhiteSur* $out/share/plasma/desktoptheme/

      mkdir -p $out/share/color-schemes
      cp -r Colors/WhiteSur* $out/share/color-schemes/
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    candy-icons
    whitesur-kde
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.kvantum
  ];

  environment.etc = {
    "xdg/kdeglobals".text = lib.mkForce ''
      [Icons]
      Theme[$i]=candy-icons

      [KDE]
      widgetStyle[$i]=kvantum
    '';

    "xdg/Kvantum/kvantum.kvconfig".text = lib.mkForce ''
      [General]
      theme=WhiteSurSharp
    '';

    "xdg/plasmarc".text = lib.mkForce ''
      [Theme]
      name[$i]=WhiteSur
    '';

    "xdg/kwinrc".text = lib.mkForce ''
      [Plugins]
      blurEnabled=true
      translucencyEnabled=true
    '';
  };

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "kvantum";
  };
}