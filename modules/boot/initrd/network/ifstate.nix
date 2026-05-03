{pkgs, ...}: {
  boot.initrd.network.ifstate = {
    allowIfstateToDrasticlyIncreaseInitrdSize = false;
    cleanupSettings = {interfaces = {};};
    enable = false;
    package = pkgs.ifstate.override {withConfigValidation = false;};
    settings = {};
  };
}
