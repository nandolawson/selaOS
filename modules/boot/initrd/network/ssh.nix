_: {
  boot.initrd.network.ssh = {
    authorizedKeyFiles = [];
    enable = false;
    extraConfig = "";
    hostKeys = [];
    ignoreEmptyHostKeys = false;
    port = 22;
    shell = "\"/bin/ash\"";
  };
}
