{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./inputMethod
  ];
  i18n = {
    defaultCharset = "UTF-8";
    defaultLocale = "de_DE.UTF-8";
    extraLocaleSettings = {};
    extraLocales = [];
    glibcLocales = pkgs.glibcLocales.override {
      allLocales = lib.elem "all" config.i18n.supportedLocales;
      locales = config.i18n.supportedLocales;
    };
    localeCharsets = {};
  };
}
