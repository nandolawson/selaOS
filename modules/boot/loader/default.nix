{ branch, pkgs, ... }:
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
        enableEditor = (branch == "developer");
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
      timeout = if branch == "developer" then 5 else 0;
    };
}