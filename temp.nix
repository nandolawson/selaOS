{ lib, pkgs, settings, ... }:

{
#  environment.etc = lib.listToAttrs (map (name: {
#    name = "xdg/autostart/kcm_${name}.desktop";
#    value = { text = "NoDisplay=true"; };
#  }) settings.removedPlasma6Settings);

  environment.systemPackages = [
    (pkgs.kdePackages.systemsettings.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        rm -f $out/share/applications/kcm_gamecontroller.desktop
      '';
    }))
  ];
  virtualisation.docker.enable = true;
}