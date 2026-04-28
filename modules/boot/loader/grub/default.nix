{ name, version, ... }:
{
    imports =
        [
            ./memtest86.nix
        ];
    boot.loader.grub = {
        backgroundColor = null;
        configurationLimit = 2;
        configurationName = "${name} ${version}";
        copyKernels = true;
        default = 0;
        device = "";
        devices = [ ];
        efiInstallAsRemovable = false;
        efiSupport = true;
        enable = false;
        enableCryptodisk = false;
        entryOptions = "--class nixos --unrestricted";
        extraConfig = "";
        extraEntries = "";
        extraEntriesBeforeNixOS = false;
        extraFiles = { };
        extraGrubInstallArgs = [ ];
        extraInstallCommands = "";
        extraPerEntryConfig = "";
        extraPrepareConfig = "";
        font = null;
        fontSize = null;
        forceInstall = false;
        forcei686 = false;
        fsIdentifier = "label";
        gfxmodeBios = "auto";
        gfxmodeEfi = "auto";
        gfxpayloadBios = "keep";
        gfxpayloadEfi = "keep";
        ipxe = { };
        mirroredBoots = [ ];
        splashImage = null;
        splashMode = "stretch";
        storePath = "/nix/store";
        subEntryOptions = "--class nixos";
        theme = null;
        timeoutStyle = "hidden";
        useOSProber = false;
        users = { };
        zfsSupport = true;
      };
}