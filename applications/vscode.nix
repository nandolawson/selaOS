{ pkgs }:

(
  pkgs.vscode.override { }
) // {
  store = {
    author = "Microsoft";
    description = {
      short = "";
      long = "";
    };
    name = "Visual Studio Code";
    screenshots = [ "" ];
    website = "https://https://code.visualstudio.com/";
  };
}
