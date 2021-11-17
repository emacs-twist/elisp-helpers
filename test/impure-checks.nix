let
  pkgs = import <nixpkgs> { };
  lib = import ../default.nix { inherit pkgs; };
  result = import ./test-fetch.nix {
    inherit (pkgs) lib;
    inherit (lib) fetchFromRecipe;
  };
  result2 = import ./test-fetch-tree.nix {
    inherit (pkgs) lib;
    inherit (lib) fetchTreeFromRecipe;
  };
in
assert (result == null);
assert (result2 == null);
pkgs.hello
