{ pkgs, ... }:

let
  selaos-logic = pkgs.writeShellApplication {
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
      detect_hardware() {
        HARDWARE=""
        for pair in "AuthenticAMD:Amd" "GenuineIntel:Intel"; do
          [[ "$(grep -m 1 "vendor_id" /proc/cpuinfo | awk '{print $NF}')" == "''${pair%%:*}" ]] && \
          HARDWARE+=" cpu''${pair#*:}"
        done
        for pair in "1002:gpuAmd" "10de:gpuNvidia" "8086:gpuIntel"; do
          [[ "$(grep -l "0x0300" /sys/bus/pci/devices/*/class | sed 's/\/class//' | xargs -I {} cat {}/vendor | cut -c 3-6)" == *"''${pair%%:*}"* ]] && \
          HARDWARE+=" ''${pair#*:}"
        done
        for pair in "0106:storageSata" "0108:storageNvme"; do
          [[ "$(cat /sys/bus/pci/devices/*/class | cut -c 3-6)" == *"''${pair%%:*}"* ]] && HARDWARE+=" ''${pair#*:}"
        done
        HARDWARE=$(echo "$HARDWARE" | xargs -n1 | sort -u | xargs)
        [[ -f /etc/selaos/hardware ]] && [[ "$HARDWARE" != "$(cat /etc/selaos/hardware)" ]] && [[ " $* " == *" --notification "* ]] && notification
        [[ " $* " == *" --save "* ]] && mkdir -p /etc/selaos && echo "$HARDWARE" > /etc/selaos/hardware
        if [[ " $* " == *" --show "* ]]
        then
          echo "--- Recognized Hardware ---"
          echo -n "Processor: "
          [[ "$HARDWARE" == *"cpuAmd"* ]] && echo -n "AMD "
          [[ "$HARDWARE" == *"cpuIntel"* ]] && echo -n "Intel "
          echo ""
          echo -n "Graphics:  "
          [[ "$HARDWARE" == *"gpuAmd"* ]] && echo -n "AMD "
          [[ "$HARDWARE" == *"gpuNvidia"* ]] && echo -n "NVIDIA "
          [[ "$HARDWARE" == *"gpuIntel"* ]] && echo -n "Intel "
          echo ""
          echo -n "Storage:   "
          [[ "$HARDWARE" == *"storageNvme"* ]] && echo -n "NVMe "
          [[ "$HARDWARE" == *"storageSata"* ]] && echo -n "SATA "
          echo ""
          echo "---------------------------"
        fi
      }

      update_system() {
        detect_hardware
        EFI_UUID=$(findmnt -no UUID /boot)
        export EFI_UUID
        export HARDWARE

        if sudo nixos-rebuild switch --flake "github:nandolawson/selaOS?ref=developer#$(uname -m)" --impure --refresh; then
          echo "------------------------------------------"
          echo "✓ System erfolgreich aktualisiert!"
        else
          echo "------------------------------------------"
          echo "✗ Fehler beim Rebuild!"
          exit 1
        fi
      }

      notification() {
        echo "Hardware verändert"
      }

      show_help() {
          cat << EOF
Usage: selaos [COMMAND]

Commands:
  hardware  Run hardware detection
  update    Update the system via flake
  help      Show this help
EOF
      }

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
  environment.systemPackages = [ selaos-logic ];
}
