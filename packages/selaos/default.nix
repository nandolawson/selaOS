{ lib, pkgs, ... }:

let
  functions = lib.concatMapStringsSep "\n" 
  (name: "source \${./scripts/selaos/${name}.sh}")
  [
    "detect_hardware"
    "show_help"
    "show_notification"
    "update_system"
  ];
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
      ${functions}
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
