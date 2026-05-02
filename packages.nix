{ inputs, ... }: {
  perSystem = { pkgs, system, ... }: 
  let
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    packages = pkgs-unstable.lib.mapAttrs' (
      name: type: pkgs-unstable.lib.nameValuePair (
        pkgs-unstable.lib.removeSuffix ".nix" name
      ) (
        import (./applications/{name}) {
          pkgs = pkgs-unstable;
        }
      )
    ) (builtins.readDir ./applications);
  };
}