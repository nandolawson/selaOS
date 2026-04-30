{ pkgs, ... }:
{
    imports = [ ./config.nix ];
    xdg.portal = {
        xdgOpenUsePortal = true;
        enable = true;
        extraPortals = [
            pkgs.kdePackages.xdg-desktop-portal-kde
            pkgs.xdg-desktop-portal-gtk
        ];
    };
}