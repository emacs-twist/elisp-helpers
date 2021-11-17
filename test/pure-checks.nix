{ hello
, parseCask
, parseRecipe
, expandPackageFiles
, flakeRefFromRecipe
}:
assert (import ./test-cask.nix { inherit parseCask; } == null);
assert (import ./test-recipe.nix { inherit parseRecipe expandPackageFiles; } == null);
assert (import ./test-recipe.nix { inherit parseRecipe expandPackageFiles; } == null);
assert (import ./test-flake-ref.nix { inherit flakeRefFromRecipe; } == null);
hello
