{ configuration, pkgs, ... }:
{
    imports =
      [
        ./efi.nix
        ./external.nix
        ./generationsDir.nix
        ./generic-extlinux-compatible.nix
        ./grub
        ./systemd-boot
        ./refind.nix
      ];
    boot.loader = {
      limine = {
        additionalFiles = { };
        biosDevice = "nodev";
        efiInstallAsRemovable = false;
        efiSupport = true;
        enable = false;
        enableEditor = {
          developer = true;
          insider = false;
          release = false;
        }.${configuration.General.channel} or false;
        enrollConfig = true;
        extraConfig = "";
        extraEntries = "";
        force = false;
        maxGenerations = 2;
        package = pkgs.limine;
        panicOnChecksumMismatch = true;
        partitionIndex = null;
        secureBoot = {
          enable = false;
          sbctl = pkgs.sbctl;
        };
        style = {
          backdrop = null;
          graphicalTerminal = {
            background = null;
            brightBackground = null;
            brightForeground = null;
            brightPalette = null;
            font = {
              scale = null;
              spacing = null;
            };
            foreground = null;
            margin = null;
            marginGradient = null;
            palette = null;
          };
          interface = {
            branding = null;
            brandingColor = null;
            helpHidden = false;
            resolution = null;
          };
          wallpaperStyle = "stretched";
          wallpapers = [ ];
        };
        validateChecksums = true;
      };
      timeout = {
        developer = null;
        insider = 0;
        release = 0;
      }.${configuration.General.channel} or 0;
    };
}