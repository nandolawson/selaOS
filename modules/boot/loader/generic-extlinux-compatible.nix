_: {
  boot.loader.generic-extlinux-compatible = {
    configurationLimit = 2;
    enable = false;
    mirroredBoots = [
      {
        path = "/boot";
      }
    ];
    populateCmd = "";
    useGenerationDeviceTree = true;
  };
}
