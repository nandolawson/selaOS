{pkgs, ...}: {
  boot.zfs = {
    allowHibernation = false;
    devNodes = "/dev/disk/by-id";
    extraPools = [];
    forceImportAll = false;
    forceImportRoot = true;
    package = pkgs.zfs;
    passwordTimeout = 0;
    pools = {};
    removeLinuxDRM = false;
    requestEncryptionCredentials = true;
    useKeyringForCredentials = false;
  };
}
