_: {
  environment.etc = {
    "flatpak/overrides/com.google.Chrome".text = ''
      [Context]
      filesystems=home;
      [Session Bus Policy]
      org.freedesktop.portal.Desktop=talk
      org.freedownloadmanager.Manager=talk
    '';
    "flatpak/overrides/org.freedownloadmanager.Manager".text = ''
      [Context]
      filesystems=home;
      [Session Bus Policy]
      org.freedownloadmanager.Manager=own
    '';
  };
}
