{ pkgs }:
(
  pkgs.gimp.override { }
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
