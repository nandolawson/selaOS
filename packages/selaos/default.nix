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
# shellcheck disable=SC1091
      source "${./scripts/detect_hardware.sh}"
      # shellcheck disable=SC1091
      source "${./scripts/show_help.sh}"
      # shellcheck disable=SC1091
      source "${./scripts/show_notification.sh}"
      # shellcheck disable=SC1091
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
