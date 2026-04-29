{ lib, settings, ... }:

{
  environment.etc = lib.listToAttrs (map (name: {
    name = "xdg/autostart/${name}.desktop";
    value = { text = "NoDisplay=true"; };
  }) settings.removedPlasma6Settings);
}