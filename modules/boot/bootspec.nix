{pkgs, ...}: {
  boot.bootspec = {
    enableValidation = false;
    extensions = {};
    package = pkgs.bootspec;
  };
}
