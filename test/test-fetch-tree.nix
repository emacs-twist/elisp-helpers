{ fetchTreeFromRecipe, lib }:
with builtins;
with lib;
# Test only on public repositories
assert (isStorePath (fetchTreeFromRecipe (readFile ./recipe1)));
assert (isStorePath (fetchTreeFromRecipe (readFile ./recipe3)));
assert (isStorePath (fetchTreeFromRecipe (readFile ./recipe4)));
null
