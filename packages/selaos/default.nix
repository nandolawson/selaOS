{ lib, pkgs, ... }:

let
  selaos = pkgs.writeShellApplication {
    name = "selaos";
    runtimeInputs = with pkgs; [
      coreutils
      pciutils
      gnugrep
      gawk
      findutils
      libnotify
      git
      nixos-rebuild
    ];
    text = ''
      source "${./scripts/detect_hardware.sh}"
      source "${./scripts/show_help.sh}"
      source "${./scripts/show_notification.sh}"
      source "${./scripts/update_system.sh}"
      case "''${1:-help}" in
          hardware)
              shift
              detect_hardware "$@"
              ;;
          update)
              update_system
              ;;
          help)
              show_help
              ;;
          *)
              show_help
              exit 1
              ;;
      esac
    '';
  };
in
{
  environment.systemPackages = [ selaos ];
}
