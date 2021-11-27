let
  pkgs = import <nixpkgs> { };
  inherit (pkgs.lib) isStorePath;
in
with builtins;
with (import ../default.nix { inherit pkgs; });
# Because these tests actually try to fetch data from remote repositories,
# they should test only on existing public repositories.
assert (isStorePath (fetchTreeFromMelpaRecipe (readFile ./recipe1)));
assert (isStorePath (fetchTreeFromMelpaRecipe (readFile ./recipe3)));
assert (isStorePath (fetchTreeFromMelpaRecipe (readFile ./recipe4)));
null
