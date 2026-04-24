{ pkgs, lib, ... }:

let
  candy-icons = pkgs.stdenv.mkDerivation rec {
    pname = "candy-icons";
    version = "latest";

    src = pkgs.fetchFromGitHub {
      owner = "EliverLara";
      repo = "candy-icons";
      rev = "master";
      # Der Hash muss für Nix Flakes im SRI-Format (sha256-...) vorliegen.
      # Du kannst ihn mit `nix-prefetch-url --unpack https://github.com/EliverLara/candy-icons/archive/master.tar.gz` ermitteln
      # oder ihn kurz leer lassen, Nix wird dir beim Build den richtigen Hash nennen.
      hash = "sha256-TzovzmfrUuaSrtpKCQxyXcih7cKSBhBtMpZLVwY/ScA="; 
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons/candy-icons
      cp -r * $out/share/icons/candy-icons/

      runHook postInstall
    '';

    meta = with lib; {
      description = "Sweet candy gradients icons for KDE Plasma";
      homepage = "https://github.com/EliverLara/candy-icons";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };
in
{
  # Fügt das Paket zu den installierten System-Paketen hinzu
  environment.systemPackages = [ candy-icons ];

  # Diese Konfiguration überschreibt die Standard-KDE-Einstellungen systemweit.
  # "[$i]" macht den Eintrag immutable (Kiosk-Mode), wenn du willst, dass User es nicht ändern können.
  environment.etc."xdg/kdeglobals".text = ''
    [Icons]
    Theme=candy-icons
  '';
}