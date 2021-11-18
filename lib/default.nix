{ pkgs ? import <nixpkgs> { }
, fromElisp
}:
with builtins;
let
  defaultFilesSpec = import ./defaultFilesSpec.nix;

  /*
   * Parse a Cask file.
   * See https://cask.readthedocs.io/en/latest/guide/dsl.html
   */
  parseCask = pkgs.callPackage ./parseCask.nix {
    inherit fromElisp;
  };

  /*
   * Parse a MELPA-style recipe and return an attribute set.
   */
  parseRecipe = pkgs.callPackage ./parseRecipe.nix {
    inherit fromElisp;
  };

  /*
   * If recipe is a string, parse it.
   */
  parseRecipeMaybe = recipe:
    if isString recipe
    then parseRecipe recipe
    else if isAttrs recipe
    then recipe
    else trace recipe (throw "Not a recipe");

  /*
   * Convert a set of MELPA-style package attributes to flake attributes
   * which suits builtins.fetchTree.
   */
  flakeRefAttrsFromRecipeAttrs = pkgs.callPackage ./flakeRefAttrsFromRecipeAttrs.nix { };

  /*
   * Convert an attribute set of flake reference to a URL-like
   * representation string.
   */
  flakeUrlRefFromAttrs = import ./flakeUrlRefFromAttrs.nix;

  /*
   * Deprecated. Use fetchTreeFromRecipe
   */
  fetchFromRecipe = pkgs.callPackage ./fetchFromRecipe.nix {
    inherit parseRecipe;
  };

  /*
   * Fetch the source repository of a recipe using builtins.fetchTree
   */
  fetchTreeFromRecipe = recipe:
    fetchTree (flakeRefAttrsFromRecipeAttrs (parseRecipeMaybe recipe));

  /*
   * Expand :files spec in a MELPA recipe.
   * dir is a path to a directory (usually the root of a project),
   * and initialSpec is a list of specs.
   *
   * If null is given as initialSpec, defaultFilesSpec is used.
   */
  expandPackageFiles = pkgs.callPackage ./expandPackageFiles.nix {
    inherit defaultFilesSpec;
  };

  /*
   * Build a URL-like representation of flake reference from a recipe string.
   */
  flakeRefFromRecipe = recipe: flakeUrlRefFromAttrs
    (flakeRefAttrsFromRecipeAttrs (parseRecipeMaybe recipe));

in
{
  inherit
    parseCask
    parseRecipe
    fetchFromRecipe
    fetchTreeFromRecipe
    expandPackageFiles
    flakeRefFromRecipe;
}
