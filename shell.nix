with import <nixpkgs> {};

gcc6Stdenv.mkDerivation rec {
    name = "not-cool-env";
    src = ./.;
    buildInputs = with pkgs; [ flex_2_5_35 ];
}
