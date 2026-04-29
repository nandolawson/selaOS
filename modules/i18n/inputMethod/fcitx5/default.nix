{ config, ... }:
{
    imports = [
        ./settings.nix
    ];
    i18n.inputMethod.fcitx5 = {
        addons = [ ];
        ignoreUserConfig = false;
        quickPhrase = { };
        quickPhraseFiles = { };
        waylandFrontend = true; #config.services.plasma6.enable;
    };
}