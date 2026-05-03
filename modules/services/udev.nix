{pkgs, ...}: {
  services.udev = {
    enable = true;
    extraHwdb = "";
    extraRules = "";
    packages = [pkgs.libfido2];
    path = [];
  };
}
