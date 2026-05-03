{config, ...}: {
  boot.uki = {
    #configFile
    #name
    #settings
    tries = null;
    inherit (config.system.image) version;
  };
}
