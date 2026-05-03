{
  inputs,
  self,
  ...
}: let
  name = "selaOS";
  version = "1.0";
in {
  flake.nixosConfigurations.x86_64 = inputs.nixpkgs-stable.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./modules
      ./packages
      ./temp.nix
      ({lib, ...}: {system.stateVersion = "25.11";})
    ];
    specialArgs = {
      configuration = {
        branch = let
          envBranch = builtins.getEnv "BRANCH";
        in
          if envBranch == "developer" || envBranch == "insider" || envBranch == "release"
          then envBranch
          else "release";

        hardware = flag:
          builtins.match ".*${flag}.*" (
            builtins.getEnv "HARDWARE"
          )
          != null;
      };
      inherit name self version;
      settings = fromTOML (builtins.readFile ./settings.toml);
    };
  };
}
