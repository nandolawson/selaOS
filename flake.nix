{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    { nixpkgs, nix-flatpak, self, ... }:
    let
      name = "selaOS";
      version = "1.0";
    in
    {
      nixosConfigurations.x86_64 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
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
          { nixpkgs.config.allowUnfree = true; }
          nix-flatpak.nixosModules.nix-flatpak
          ./modules
          ./packages
          (
            { lib, ... }:
            {
              system.stateVersion = "25.11";
            }
          )
        ];
      };
    };
}
