{
  description = "selaOS";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    flake-utils,
    nixpkgs-stable,
    nixpkgs-unstable,
    self,
    ...
  }:
  let
    name = "selaOS";
    version = "1.0";
  in
    {
      nixosConfigurations.x86_64 = nixpkgs-stable.lib.nixosSystem {
        modules = [
          ./modules
          ./packages
          ./temp.nix
          (
            {
              lib,
              ...
            }: {
            }
          )
        ];
        specialArgs = {
          configuration = {
            branch = let
              envBranch = builtins.getEnv "BRANCH";
            in
              if envBranch == "developer" || envBranch == "insider" || envBranch == "release"
              then envBranch
              else "release";
            hardware = flag: builtins.match ".*${flag}.*" (
              builtins.getEnv "HARDWARE"
            ) != null;
          };
          inherit name self version;
          settings = builtins.fromTOML (
            builtins.readFile ./settings.toml
          );
        };
        system = "x86_64-linux";
      };
    } // (
      flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          packages = pkgs.lib.mapAttrs' (
            name:
            type: pkgs.lib.nameValuePair (
              pkgs.lib.removeSuffix ".nix" name
            ) (
              import (./applications + "/${name}") {
                inherit pkgs;
              }
            )
          ) (
          builtins.readDir ./applications
        );
      }
    )
  );
}
