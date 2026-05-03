{pkgs, ...}: {
  hardware.bluetooth = {
    disabledPlugins = [];
    enable = true;
    hsphfpd.enable = false;
    input = {};
    network = {};
    package = pkgs.bluez;
    powerOnBoot = true;
    settings = {
      General = {
        RememberPowered = true;
        FastConnectable = true;
      };
    };
  };
}
