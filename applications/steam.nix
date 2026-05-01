{ pkgs }:
(
  pkgs.steam.override {
    dedicatedServer.openFirewall = true;
    enable = true;
    remotePlay.openFirewall = true;
  }
) // {
  store = {
    author = "";
    description = {
      short = "";
      long = "";
    };
    name = "";
    screenshots = [ "" ];
    website = "";
  };
}
