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
      configPath = /etc/selaos/configuration.toml;
      configuration = if builtins.pathExists configPath
      then builtins.fromTOML (builtins.readFile configPath)
      else builtins.throw "FEHLER: Die Datei ${toString configPath} wurde nicht gefunden. Das System kann ohne diese Konfiguration nicht gebaut werden.";
    in
    {
      nixosConfigurations.x86_64 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit self name version configuration; };
        modules = [
          { nixpkgs.config.allowUnfree = true; }
          nix-flatpak.nixosModules.nix-flatpak
          ./configuration.nix
          ./temp.nix
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
