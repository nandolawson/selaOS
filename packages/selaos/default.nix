{ lib, pkgs, ... }:

let
functions = lib.concatMapStringsSep "\n" 
  (name: ''
    # shellcheck disable=SC1090,SC1091
    source "${./functions/${name}.sh}"
  '')
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
            ARGS=""
              for arg in "$@"; do
                case "$arg" in
                  --show) ARGS+=" -s" ;;
                  --save) ARGS+=" -v" ;;
                  --notification) ARGS+=" -n" ;;
                  *) ARGS+=" $arg" ;;
                esac
              done
              # shellcheck disable=SC2086
              detect_hardware $ARGS
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
  environment = {
    #environment.etc."bash_completion.d/selaos".source = ./scripts/completion.sh;
    systemPackages = [ selaos ];
  };
}
