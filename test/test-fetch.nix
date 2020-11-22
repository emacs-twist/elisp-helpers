with builtins;
with (import <nixpkgs> {}).lib;
with (import ../default.nix {});
# Test only on public repositories
assert (isStorePath (fetchFromRecipe (readFile ./recipe1)));
assert (isStorePath (fetchFromRecipe (readFile ./recipe3)));
assert (isStorePath (fetchFromRecipe (readFile ./recipe4)));
null
