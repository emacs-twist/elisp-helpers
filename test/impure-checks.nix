let
  pkgs = import <nixpkgs> { };
  lib = import ../default.nix { inherit pkgs; };
  result = import ./test-fetch.nix {
    inherit (pkgs) lib;
    inherit (lib) fetchFromRecipe;
  };
in
assert (result == null);
pkgs.hello
