{ config, pkgs, ... }:
{
    imports = [
        ./settings.nix
    ];
    i18n.inputMethod.fcitx5 = {
        addons = with pkgs; [
            "fcitx5-gtk"
        ];
        ignoreUserConfig = false;
        quickPhrase = { };
        quickPhraseFiles = { };
        waylandFrontend = true; #config.services.plasma6.enable;
    };
}