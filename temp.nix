{ lib, settings, ... }:

{
#  environment.etc = lib.listToAttrs (map (name: {
#    name = "xdg/autostart/kcm_${name}.desktop";
#    value = { text = "NoDisplay=true"; };
#  }) settings.removedPlasma6Settings);
}