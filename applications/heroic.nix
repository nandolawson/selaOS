{ pkgs }:
(
  pkgs.heroic.override { }
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
