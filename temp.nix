{ lib, settings, ... }:

{
#  environment.etc = lib.listToAttrs (map (name: {
#    name = "xdg/autostart/kcm_${name}.desktop";
#    value = { text = "NoDisplay=true"; };
#  }) settings.removedPlasma6Settings);
  environment.etc."xdg/autostart/kcm_gamecontroller.desktop".text = ''
  [Desktop Entry]
  Name=Game Controller
  NoDisplay=true
  Type=Service
  X-KDE-ServiceTypes=KCModule'';
}