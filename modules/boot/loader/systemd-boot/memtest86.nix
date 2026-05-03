{configuration, ...}: {
  boot.loader.systemd-boot.memtest86 = {
    enable = configuration.branch == "developer";
    sortKey = "o_memtest86";
  };
}
