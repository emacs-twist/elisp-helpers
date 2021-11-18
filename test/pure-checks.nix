{ hello
, parseCask
, parseRecipe
, expandPackageFiles
, flakeRefUrlFromRecipe
}:
assert (import ./test-cask.nix { inherit parseCask; } == null);
assert (import ./test-recipe.nix { inherit parseRecipe expandPackageFiles; } == null);
assert (import ./test-recipe.nix { inherit parseRecipe expandPackageFiles; } == null);
assert (import ./test-flake-ref.nix { inherit flakeRefUrlFromRecipe; } == null);
hello
