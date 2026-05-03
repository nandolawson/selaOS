_: {
  boot.crashDump = {
    enable = false;
    kernelParams = [
      "1"
      "boot.shell_on_fail"
    ];
    reservedMemory = "128M";
  };
}
