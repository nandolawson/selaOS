{ configuration, ... }:
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
        editor = {
            developer = true;
            insider = false;
            release = false;
        }.${configuration.General.channel} or false;
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