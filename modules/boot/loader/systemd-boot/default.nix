{ configuration, name, ... }:
{
    imports =
        [
            ./edk2-uefi-shell.nix
            ./memtest86.nix
            ./netbootxyz.nix
        ];
    boot.loader.systemd-boot = {
        configurationLimit = 2;
        consoleMode = "max";
        editor = (configuration.branch == "developer");
        enable = true;
        extraEntries = { };
        extraFiles = { };
        extraInstallCommands = "";
        graceful = false;
        #installDeviceTree = "with config.hardware.deviceTree; enable && name != null";
        rebootForBitlocker = false;
        sortKey = "${name}";
        windows = { };
        xbootldrMountPoint = null;
    };
}