{inputs, ...}: {
  perSystem = {system, ...}: let
    pkgs = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages =
      pkgs.lib.mapAttrs' (
        name: type:
          pkgs.lib.nameValuePair (
            pkgs.lib.removeSuffix ".nix" name
          ) (
            import (./applications + "/${name}") {
              inherit pkgs;
            }
          )
      ) (
        builtins.readDir ./applications
      );
  };
}
