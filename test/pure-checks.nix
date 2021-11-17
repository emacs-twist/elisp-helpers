{ hello
, parseCask
, parseRecipe
, expandPackageFiles
}:
assert (import ./test-cask.nix { inherit parseCask; } == null);
assert (import ./test-recipe.nix { inherit parseRecipe expandPackageFiles; } == null);
assert (import ./test-recipe.nix { inherit parseRecipe expandPackageFiles; } == null);
hello
