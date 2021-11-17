{ hello
, parseCask
, parseRecipe
, expandPackageFiles
, flakeRef
}:
assert (import ./test-cask.nix { inherit parseCask; } == null);
assert (import ./test-recipe.nix { inherit parseRecipe expandPackageFiles; } == null);
assert (import ./test-recipe.nix { inherit parseRecipe expandPackageFiles; } == null);
assert (import ./test-flake-ref.nix { inherit flakeRef; } == null);
hello
