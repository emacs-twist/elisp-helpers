{ lib
, fromElisp
}:
with builtins;
let
  callLibs = f:
    let
      func = if isPath f then import f else f;
    in
    func (intersectAttrs (lib.functionArgs func) {
      inherit lib fromElisp;
    });
in
lib.makeExtensible (self: {
  defaultFilesSpec = import ./defaultFilesSpec.nix;

  /* Parse a Cask file.
    See https://cask.readthedocs.io/en/self/guide/dsl.html
    */
  parseCask = callLibs ./parseCask.nix;

  /** Parse a package list used by GNU ELPA and NonGNU ELPA.

    See https://git.savannah.gnu.org/cgit/emacs/elpa.git/tree/elpa-packages for example.
    */
  parseElpaPackages = callLibs ./parseElpaPackages.nix;

  /* Parse a MELPA-style recipe and return an attribute set.
    */
  parseMelpaRecipe = callLibs ./parseMelpaRecipe.nix;

  /* If recipe is a string, parse it.
    */
  parseMelpaRecipeMaybe = recipe:
    if isString recipe
    then self.parseMelpaRecipe recipe
    else if isAttrs recipe
    then recipe
    else trace recipe (throw "A recipe must be either a string or an attr set");

  /* Convert a set of MELPA-style package attributes to flake attributes
    which suits builtins.fetchTree.
   */
  flakeRefAttrsFromMelpaRecipeAttrs = callLibs ./flakeRefAttrsFromMelpaRecipeAttrs.nix;

  /* Build an attribute set of flake reference from a recipe string or
    attribute set.
   */
  flakeRefAttrsFromMelpaRecipe = recipe:
    self.flakeRefAttrsFromMelpaRecipeAttrs (self.parseMelpaRecipeMaybe recipe);

  /* Build a URL-like representation of flake reference from a recipe string
    or attribute set.
   */
  flakeRefUrlFromMelpaRecipe = recipe:
    self.flakeRefUrlFromFlakeRefAttrs
      (self.flakeRefAttrsFromMelpaRecipeAttrs (self.parseMelpaRecipeMaybe recipe));

  /* Convert an attribute set of an ELPA package to flake attributes.
    */
  flakeRefAttrsFromElpaAttrs = callLibs ./flakeRefAttrsFromElpaAttrs.nix;

  /* Convert an attribute set of flake reference to a URL-like
    representation string.
    */
  flakeRefUrlFromFlakeRefAttrs = import ./flakeRefUrlFromFlakeRefAttrs.nix;

  /* Fetch the source repository of a recipe using builtins.fetchTree
   */
  fetchTreeFromMelpaRecipe = recipe:
    fetchTree (self.flakeRefAttrsFromMelpaRecipeAttrs (self.parseMelpaRecipeMaybe recipe));

  /* Expand :files spec in a MELPA recipe.
    dir is a path to a directory (usually the root of a project),
    and initialSpec is a list of specs.

    If null is given as initialSpec, defaultFilesSpec is used.
   */
  expandMelpaRecipeFiles = callLibs ./expandMelpaRecipeFiles.nix {
    inherit (self) defaultFilesSpec;
  };

  # Deprecated functions
  fetchFromRecipe = str:
    trace "fetchFromRecipe is deprecated. Use fetchTreeFromMelpaRecipe instead"
      (self.fetchTreeFromMelpaRecipe str);
  parseRecipe = str:
    trace "parseRecipe is deprecated. Use parseMelpaRecipe instead"
      (self.parseMelpaRecipe str);
  fetchTreeFromRecipe = x:
    trace "fetchTreeFromRecipe is deprecated. Use fetchTreeFromMelpaRecipe instead"
      (self.fetchTreeFromMelpaRecipe x);
  flakeRefAttrsFromRecipe = x:
    trace "flakeRefAttrsFromRecipe is deprecated. Use flakeRefAttrsFromMelpaRecipe instead"
      (self.flakeRefAttrsFromMelpaRecipe x);
  flakeRefUrlFromRecipe = x:
    trace "flakeRefUrlFromRecipe is deprecated. Use flakeRefUrlFromMelpaRecipe instead"
      (self.flakeRefUrlFromMelpaRecipe x);
  expandPackageFiles = x: y: z:
    trace "expandPackageFiles is deprecated. Use expandMelpaRecipeFiles instead"
      (self.expandMelpaRecipeFiles x y z);
})
