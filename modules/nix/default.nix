{ configuration, ... }:
{
    imports = [
        ./gc.nix
        ./settings.nix
    ];
    nix = {
        registry = {
            repository.to = {
                shallow = !(configuration.branch == "developer");
                type = "git";
                url = "https://github.com/nandolawson/selaOS.git";
            };
        };
        #settings.flake-registry-only = !(configuration.branch == "developer");
    };
}