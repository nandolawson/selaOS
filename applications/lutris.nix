{ pkgs }:
(
  pkgs.lutris.override { }
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
