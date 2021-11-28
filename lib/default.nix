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
  parseMelpaRecipe = pkgs.callPackage ./parseMelpaRecipe.nix {
    inherit fromElisp;
  };

  /*
   * If recipe is a string, parse it.
   */
  parseMelpaRecipeMaybe = recipe:
    if isString recipe
    then parseMelpaRecipe recipe
    else if isAttrs recipe
    then recipe
    else trace recipe (throw "A recipe must be either a string or an attr set");

  /*
   * Convert a set of MELPA-style package attributes to flake attributes
   * which suits builtins.fetchTree.
   */
  flakeRefAttrsFromMelpaRecipeAttrs = pkgs.callPackage ./flakeRefAttrsFromMelpaRecipeAttrs.nix { };

  /*
   * Build an attribute set of flake reference from a recipe string or
   * attribute set.
   */
  flakeRefAttrsFromMelpaRecipe = recipe:
    flakeRefAttrsFromMelpaRecipeAttrs (parseMelpaRecipeMaybe recipe);

  /*
   * Build a URL-like representation of flake reference from a recipe string
   * or attribute set.
   */
  flakeRefUrlFromMelpaRecipe = recipe: flakeRefUrlFromFlakeRefAttrs
    (flakeRefAttrsFromMelpaRecipeAttrs (parseMelpaRecipeMaybe recipe));

  /*
   * Convert an attribute set of an ELPA package to flake attributes.
   */
  flakeRefAttrsFromElpaAttrs = pkgs.callPackage ./flakeRefAttrsFromElpaAttrs.nix { };

  /*
   * Convert an attribute set of flake reference to a URL-like
   * representation string.
   */
  flakeRefUrlFromFlakeRefAttrs = import ./flakeRefUrlFromFlakeRefAttrs.nix;

  /*
   * Fetch the source repository of a recipe using builtins.fetchTree
   */
  fetchTreeFromMelpaRecipe = recipe:
    fetchTree (flakeRefAttrsFromMelpaRecipeAttrs (parseMelpaRecipeMaybe recipe));

  /*
   * Expand :files spec in a MELPA recipe.
   * dir is a path to a directory (usually the root of a project),
   * and initialSpec is a list of specs.
   *
   * If null is given as initialSpec, defaultFilesSpec is used.
   */
  expandMelpaRecipeFiles = pkgs.callPackage ./expandMelpaRecipeFiles.nix {
    inherit defaultFilesSpec;
  };

in
{
  inherit
    parseCask
    parseElpaPackages
    parseMelpaRecipe
    fetchTreeFromMelpaRecipe
    flakeRefAttrsFromElpaAttrs
    flakeRefUrlFromFlakeRefAttrs
    expandMelpaRecipeFiles;

  /*
   * Deprecated functions
   */
  fetchFromRecipe = str:
    trace "fetchFromRecipe is deprecated. Use fetchTreeFromMelpaRecipe instead"
      (fetchTreeFromMelpaRecipe str);
  parseRecipe = str:
    trace "parseRecipe is deprecated. Use parseMelpaRecipe instead"
      (parseMelpaRecipe str);
  fetchTreeFromRecipe = x:
    trace "fetchTreeFromRecipe is deprecated. Use fetchTreeFromMelpaRecipe instead"
      (fetchTreeFromMelpaRecipe x);
  flakeRefAttrsFromRecipe = x:
    trace "flakeRefAttrsFromRecipe is deprecated. Use flakeRefAttrsFromMelpaRecipe instead"
      (flakeRefAttrsFromMelpaRecipe x);
  flakeRefUrlFromRecipe = x:
    trace "flakeRefUrlFromRecipe is deprecated. Use flakeRefUrlFromMelpaRecipe instead"
      (flakeRefUrlFromMelpaRecipe x);
  expandPackageFiles = x: y: z:
    trace "expandPackageFiles is deprecated. Use expandMelpaRecipeFiles instead"
      (expandMelpaRecipeFiles x y z);
}
