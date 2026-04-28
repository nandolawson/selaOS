detect_hardware() {
    HARDWARE=""
    for pair in "AuthenticAMD:Amd" "GenuineIntel:Intel"
    do
        [[ "$(grep -m 1 "vendor_id" /proc/cpuinfo | awk '{print $NF}')" == "''${pair%%:*}" ]] && \
        HARDWARE+=" cpu''${pair#*:}"
    done
    for pair in "1002:gpuAmd" "10de:gpuNvidia" "8086:gpuIntel"
    do
        [[ "$(grep -l "0x0300" /sys/bus/pci/devices/*/class | sed 's/\/class//' | xargs -I {} cat {}/vendor | cut -c 3-6)" == *"''${pair%%:*}"* ]] && \
        HARDWARE+=" ''${pair#*:}"
    done
    for pair in "0106:storageSata" "0108:storageNvme"
    do
        [[ "$(cat /sys/bus/pci/devices/*/class | cut -c 3-6)" == *"''${pair%%:*}"* ]] && HARDWARE+=" ''${pair#*:}"
    done
    HARDWARE=$(echo "$HARDWARE" | xargs -n1 | sort -u | xargs)
    [[ -f /etc/selaos/hardware ]] && [[ "$HARDWARE" != "$(cat /etc/selaos/hardware)" ]] && [[ " $* " == *" --notification "* ]] && show-notification
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