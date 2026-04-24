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
in {
  environment.systemPackages = [ candy-icons ]; # <--- WICHTIG
  environment.etc."xdg/kdeglobals".text = lib.mkForce ''
    [Icons]
    Theme[$i]=candy-icons
  '';
}