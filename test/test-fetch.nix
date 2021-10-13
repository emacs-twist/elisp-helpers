{ fetchFromRecipe, lib }:
with builtins;
with lib;
# Test only on public repositories
assert (isStorePath (fetchFromRecipe (readFile ./recipe1)));
assert (isStorePath (fetchFromRecipe (readFile ./recipe3)));
assert (isStorePath (fetchFromRecipe (readFile ./recipe4)));
null
