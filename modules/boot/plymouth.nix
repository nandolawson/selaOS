{ config, configuration, pkgs, self, ... }:
{
    boot.plymouth = {
      enable = {
        developer = false;
        insider = true;
        release = true;
      }.${configuration.General.channel} or true;
      extraConfig = "";
      font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
      logo = "${self}/assets/logo.svg";
      package = pkgs.plymouth.override { systemd = config.boot.initrd.systemd.package; };
      #themePackages =
      theme = "bgrt";
      tpm2-totp = {
        enable = false;
        package = pkgs.tpm2-totp-with-plymouth;
      };
    };
}