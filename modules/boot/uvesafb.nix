_: {
  uvesafb = {
    enable = false;
    gfx-mode = "1024x768-32";
    v86d.package = ''
      config.boot.kernelPackages.v86d.overrideAttrs (old: {
          hardeningDisable = [ "all" ];
      })'';
  };
}
