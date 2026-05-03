{
  lib,
  name,
  version,
  ...
}: {
  system.nixos = {
    #codeName = "Xantusia";
    distroName = name;
    distroId = lib.toLower name;
    label = "${name}-${version}";
    #release = version;
    tags = [];
    variantName = null;
    variant_id = null;
  };
}
