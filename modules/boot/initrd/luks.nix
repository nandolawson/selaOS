_: {
  boot.initrd.luks = {
    cryptoModules = [];
    devices = {};
    fido2Support = false;
    gpgSupport = false;
    mitigateDMAAttacks = true;
    reusePassphrases = true;
    yubikeySupport = false;
  };
}
