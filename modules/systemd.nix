{ ... }:
{
    systemd = {
        tmpfiles.rules = [
            "d /var/lib/flatpak/user-data 0775 root users -"
            "L+ %h/.var - - - - /var/lib/flatpak/user-data/%u"
            "L+ /var/lib/flatpak/overrides/global - - - - socket=wayland,fallback-x11;device=dri;filesystems=home;"
        ];
    };
}