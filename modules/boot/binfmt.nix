_: {
  boot.binfmt = {
    addEmulatedSystemsToNixSandbox = false;
    emulatedSystems = [];
    preferStaticEmulators = false;
    registrations = {};
  };
}
