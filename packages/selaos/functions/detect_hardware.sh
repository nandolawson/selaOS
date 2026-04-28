detect_hardware() {
    local show=false
    local save=false
    local notify=false
    local OPTIND opt
    while getopts "svn" opt; do
        case "''${opt}" in
            s) show=true ;;
            v) save=true ;;
            n) notify=true ;;
            *) return 1 ;;
        esac
    done
    shift "$((OPTIND-1))"
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
        [[ "$(cat /sys/bus/pci/devices/*/class | cut -c 3-6)" == *"''${pair%%:*}"* ]] && \
        HARDWARE+=" ''${pair#*:}"
    done
    
    HARDWARE=$(echo "$HARDWARE" | xargs -n1 | sort -u | xargs)
    if [[ "$notify" == true ]]; then
        [[ -f /etc/selaos/hardware ]] && [[ "$HARDWARE" != "$(cat /etc/selaos/hardware)" ]] && show_notification
    fi

    if [[ "$save" == true ]]; then
        mkdir -p /etc/selaos && echo "$HARDWARE" > /etc/selaos/hardware
    fi
    if [[ "$show" == true ]]; then
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