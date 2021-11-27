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

  /**
   * Parse a package list used by GNU ELPA and NonGNU ELPA.
   *
   * See https://git.savannah.gnu.org/cgit/emacs/elpa.git/tree/elpa-packages for example.
   */
  parseElpaPackages = pkgs.callPackage ./parseElpaPackages.nix {
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
  flakeRefUrlFromFlakeRefAttrs = import ./flakeRefUrlFromFlakeRefAttrs.nix;

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

in
{
  inherit
    parseCask
    parseElpaPackages
    parseRecipe
    fetchTreeFromRecipe
    flakeRefUrlFromFlakeRefAttrs
    expandPackageFiles;

  /*
   * Build an attribute set of flake reference from a recipe string or
   * attribute set.
   */
  flakeRefAttrsFromRecipe = recipe:
    flakeRefAttrsFromRecipeAttrs (parseRecipeMaybe recipe);

  /*
   * Build a URL-like representation of flake reference from a recipe string
   * or attribute set.
   */
  flakeRefUrlFromRecipe = recipe: flakeRefUrlFromFlakeRefAttrs
    (flakeRefAttrsFromRecipeAttrs (parseRecipeMaybe recipe));

  /*
   * Deprecated. Use fetchTreeFromRecipe instead.
   */
  fetchFromRecipe = fetchTreeFromRecipe;
}
