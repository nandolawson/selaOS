_: {
  system.activationScripts = {
    flatpak-overrides.text = ''
      mkdir -p /var/lib/flatpak/overrides
      for file in /etc/flatpak/overrides/*; do
        if [ -e "$file" ]; then
          ln -sf "$file" "/var/lib/flatpak/overrides/$(basename "$file")"
        fi
      done
    '';
  };
}
