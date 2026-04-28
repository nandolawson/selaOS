{ name, version, ... }:
{
  system = {
    nixos = {
      distroName = name;
      distroId = lib.toLower name;
      label = "${name}-${version}";
      versionSuffix = " Test";
      version = version;
    };
  };
}