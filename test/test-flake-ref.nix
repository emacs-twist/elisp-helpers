let
  pkgs = import <nixpkgs> { };
in
with (import ../default.nix { inherit pkgs; });
with builtins;
pkgs.lib.runTests {
  testRecipe1 = {
    expr = flakeRefUrlFromRecipe (readFile ./recipe1);
    expected = "github:nonsequitur/smex";
  };

  testRecipe2 = {
    expr = flakeRefUrlFromRecipe (readFile ./recipe2);
    expected = "github:someuser/mypackage";
  };

  testRecipe5 = {
    expr = flakeRefUrlFromRecipe (readFile ./recipe5);
    expected = "git+https://framagit.org/steckerhalter/discover-my-major.git";
  };

  testRecipe6 = {
    expr = flakeRefUrlFromRecipe (readFile ./recipe6);
    expected = "github:jcaw/elnode/melpa";
  };

  testRecipe7 = {
    expr = flakeRefUrlFromRecipe (readFile ./recipe7);
    expected = "git://github.com/edolstra/dwarffs";
  };

  testGitlab = {
    expr = flakeRefUrlFromRecipe (readFile ./gitlab-recipe);
    expected = "git+https://gitlab.com/joewreschnig/gitlab-ci-mode.git";
  };
}
