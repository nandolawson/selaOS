{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs =
    {
      nixpkgs,
      self,
      ...
    }:
    let
      name = "selaOS";
      version = "1.0";
    in
    {
      nixosConfigurations.x86_64 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          settings = builtins.fromTOML (builtins.readFile ./settings.toml);
          inherit self name version;
          configuration = {
            branch = let
              envBranch = builtins.getEnv "BRANCH";
            in
              if envBranch == "release" || envBranch == "insider" || envBranch == "developer"
              then envBranch
              else "release";
            hardware = flag: builtins.match ".*${flag}.*" (builtins.getEnv "HARDWARE") != null;
          };
        };
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
      };
    };
}
