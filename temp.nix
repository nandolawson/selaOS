{ pkgs, lib, ... }:
let
  candy-icons = pkgs.stdenv.mkDerivation {
    pname = "candy-icons";
    version = "1.0";

    src = ./candy-icons; # <- MUSS sauber definiert sein

    installPhase = ''
      mkdir -p $out/share/icons
      cp -r $src $out/share/icons/candy-icons
    '';
  };
in
{
  environment.systemPackages = [ candy-icons ];

  environment.etc."xdg/kdeglobals".text = lib.mkForce ''
    [Icons]
    Theme[$i]=candy-icons
  '';
}