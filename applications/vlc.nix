{ pkgs }:

(
  pkgs.vlc.override {}
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
