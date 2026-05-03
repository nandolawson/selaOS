_: {
  nix.settings = {
    auto-optimise-store = true;
    keep-outputs = false;
    keep-derivations = false;
    experimental-features = ["nix-command" "flakes"];
  };
}
