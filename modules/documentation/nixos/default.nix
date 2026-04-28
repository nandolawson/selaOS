{ ... }:
{
    imports = [ options.nix ];
    documentation.nixos = {
      checkRedirects = true;
      enable = false;
      extraModules = [ ];
      extraModuleSources = [ ];
      includeAllModules = false;
  };
}