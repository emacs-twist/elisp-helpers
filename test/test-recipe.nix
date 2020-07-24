with (import ../default.nix { pkgs = import <nixpkgs> {}; });
let
  recipe1 = parseRecipe (builtins.readFile ./recipe1);
  recipe2 = parseRecipe (builtins.readFile ./recipe2);
  recipe3 = parseRecipe (builtins.readFile ./recipe3);
in
# recipe 1
assert (recipe1.pname == "smex");
assert (recipe1.repo == "nonsequitur/smex");
assert (recipe1.fetcher == "github");
assert (recipe1.files == null);
# recipe 2
assert (recipe2.pname == "mypackage");
assert (recipe2.repo == "someuser/mypackage");
assert (recipe2.fetcher == "github");
assert (recipe2.files == ["mypackage.el"]);
# recipe 3
assert (recipe3.pname == "flymake-perlcritic");
assert (recipe3.repo == "illusori/emacs-flymake-perlcritic");
assert (recipe3.fetcher == "github");
assert (recipe3.files == ["*.el" ["bin" "bin/flymake_perlcritic"]]);
null
