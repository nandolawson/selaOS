{
  description = "selaOS";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    nixpkgs-stable,
    nixpkgs-unstable,
    self,
    ...
  }:
  let
    name = "selaOS";
    version = "1.0";
    system = "x86_64-linux";
    
    # Unstable pkgs für die App-Library
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    # System-Konfiguration
    nixosConfigurations.x86_64 = nixpkgs-stable.lib.nixosSystem {
      inherit system;
      modules = [
        ./modules
        ./packages
        ./temp.nix
        ({ lib, ... }: { system.stateVersion = "25.11"; })
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
        settings = builtins.fromTOML (builtins.readFile ./settings.toml);
      };
    };

    # App-Store / Packages (Direkt für x86_64-linux ohne Utils-Wrapper)
    packages.${system} = pkgs-unstable.lib.mapAttrs' (
      name: type: pkgs-unstable.lib.nameValuePair (
        pkgs-unstable.lib.removeSuffix ".nix" name
      ) (
        import (./applications + "/${name}") {
          pkgs = pkgs-unstable;
        }
      )
    ) (builtins.readDir ./applications);
  };
}