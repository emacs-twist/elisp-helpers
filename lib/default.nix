{ pkgs ? import <nixpkgs> { }
, fromElisp
}:
with builtins;
let
  defaultFilesSpec = import ./defaultFilesSpec.nix;

  parseCask = pkgs.callPackage ./parseCask.nix {
    inherit fromElisp;
  };

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

  fetchFromRecipe = pkgs.callPackage ./fetchFromRecipe.nix {
    inherit parseRecipe;
  };

  /*
   * Fetch the source repository of a recipe using builtins.fetchTree
   */
  fetchTreeFromRecipe = recipe: pkgs.callPackage ./fetchTreeFromRecipe.nix
    { }
    (parseRecipeMaybe recipe);

  expandPackageFiles = pkgs.callPackage ./expandPackageFiles.nix {
    inherit defaultFilesSpec;
  };

  /*
   * Build a URL-like representation of flake reference from a recipe string.
   */
  flakeRefFromRecipe = recipe: pkgs.callPackage ./flakeRefFromRecipe.nix
    (parseRecipeMaybe recipe);

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
