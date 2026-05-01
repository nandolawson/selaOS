{
  description = "selaOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };
  outputs = {
    nixpkgs,
    self,
    ...
  }:
  let
    name = "selaOS";
    version = "1.0";
  in
  {
    nixosConfigurations = {
      x86_64 = nixpkgs.lib.nixosSystem {
        modules = [
          ./modules
          ./packages
          ./temp.nix
          (
            {
              lib,
              ...
            }:
          )
        ];
        specialArgs = {
          configuration = {
            branch = let
            envBranch = builtins.getEnv "BRANCH";
            in
              if envBranch == "release" || envBranch == "insider" || envBranch == "developer"
              then envBranch
              else "release";
            hardware = flag: builtins.match ".*${flag}.*" (builtins.getEnv "HARDWARE") != null;
          };
          inherit self name version;
          settings = builtins.fromTOML (
            builtins.readFile ./settings.toml
          );
        };
        system = "x86_64-linux";
      };
    };
  };
}
