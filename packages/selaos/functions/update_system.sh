update_system() {
    detect_hardware
    UUID_VAL=$(findmnt -no UUID /boot)
    if sudo EFI_UUID="$UUID_VAL" HARDWARE="$HARDWARE" \
        nixos-rebuild switch \
        --flake "github:nandolawson/selaOS?ref=developer#$(uname -m)" \
        --impure --refresh; then
        echo "------------------------------------------"
        echo "✓ System erfolgreich aktualisiert!"
    else
        echo "------------------------------------------"
        echo "✗ Fehler beim Rebuild!"
        exit 1
    fi
}