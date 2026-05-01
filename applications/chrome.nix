{ pkgs }:

(
  pkgs.google-chrome.override { }
) // {
  store = {
    author = "Google";
    description = {
      short = "";
      long = "";
    };
    name = "Google Chrome";
    screenshots = [ "" ];
    website = "https://google.com/chrome/";
  };
}
