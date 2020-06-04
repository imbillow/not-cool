with import <nixpkgs> {};

let
  flex = (import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "flex-2.6.0";
    url = "https://github.com/nixos/nixpkgs-channels/";
    ref = "refs/heads/nixos-20.03";
    rev = "1971f39ab19dde7d74841bbb4c1e50c94e873830";
  }) {}).flex;
  gcc = (import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "gcc-5.3.0";
    url = "https://github.com/nixos/nixpkgs-channels/";
    ref = "refs/heads/nixos-20.03";
    rev = "d5eec25ff97b0d21fe8f08b2a3d70ddf50d0fc87";
  }) {}).gcc;
in
  stdenv.mkDerivation rec {
    name = "not-cool-env";
    src = ./.;
    buildInputs = with pkgs; [ flex gcc cowsay ];
  }
