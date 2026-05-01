{ pkgs }:
(
  pkgs.discord.override {
    withOpenASAR = true;
    withVencord = true;
  }
) // {
  store = {
    author = "Discord";
    description = {
      short = "Discord mit Performance-Boost.";
      long = "Ein sehr langer Text über Vencord und OpenASAR...";
    };
    name = "Discord";
    screenshots = [ "https://deine-distro.de/assets/1.png" ];
    website = "https://discord.com/";
  };
}
