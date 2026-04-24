{ pkgs, lib, ... }:

let
  # 1. Candy Icons (Bleiben wie gehabt)
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

  # 2. WhiteSur KDE (Das Glas-Theme)
  whitesur-kde = pkgs.stdenv.mkDerivation {
    pname = "whitesur-kde";
    version = "latest";
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "WhiteSur-kde";
      rev = "master";
      hash = "sha256-t0bCb1X6BprttUUEcfVqjLskulbFxwXQwUMBn6p8Ho8="; # <-- HIER den Hash aus Schritt 1 einfügen!
    };
    dontBuild = true;
    installPhase = ''
      # Kvantum (Das ist das "Liquid Glass" für Fenster)
      mkdir -p $out/share/Kvantum
      cp -r Kvantum/WhiteSur* $out/share/Kvantum/

      # Plasma Style (Taskleiste)
      mkdir -p $out/share/plasma/desktoptheme
      cp -r Plasma/WhiteSur* $out/share/plasma/desktoptheme/

      # Farbschemata
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
    # Systemweite Icons & Widget-Style
    "xdg/kdeglobals".text = lib.mkForce ''
      [Icons]
      Theme[$i]=candy-icons

      [KDE]
      widgetStyle[$i]=kvantum
    '';

    # Kvantum Konfiguration für Glass-Effekt
    "xdg/Kvantum/kvantum.kvconfig".text = lib.mkForce ''
      [General]
      theme=WhiteSurSharp
    '';

    # Plasma Desktop (Taskleiste)
    "xdg/plasmarc".text = lib.mkForce ''
      [Theme]
      name[$i]=WhiteSur
    '';

    # Weichzeichnen (Blur) in KWin erzwingen
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