{ self, ... }:
{
    imports = [
        ./gc.nix
        ./settings.nix
    ];
    nix = {
        registry.selaos.flake = self;
    };
}