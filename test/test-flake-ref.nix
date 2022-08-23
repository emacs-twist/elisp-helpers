let
  pkgs = import <nixpkgs> {};
in
  with (import ../default.nix {inherit pkgs;});
  with builtins;
    pkgs.lib.runTests {
      testRecipe1 = {
        expr = flakeRefUrlFromMelpaRecipe (readFile ./recipe1);
        expected = "github:nonsequitur/smex";
      };

      testRecipe2 = {
        expr = flakeRefUrlFromMelpaRecipe (readFile ./recipe2);
        expected = "github:someuser/mypackage";
      };

      testRecipe5 = {
        expr = flakeRefUrlFromMelpaRecipe (readFile ./recipe5);
        expected = "git+https://framagit.org/steckerhalter/discover-my-major.git";
      };

      testRecipe6 = {
        expr = flakeRefUrlFromMelpaRecipe (readFile ./recipe6);
        expected = "github:jcaw/elnode/melpa";
      };

      testRecipe7 = {
        expr = flakeRefUrlFromMelpaRecipe (readFile ./recipe7);
        expected = "git://github.com/edolstra/dwarffs";
      };

      testGitlab = {
        expr = flakeRefUrlFromMelpaRecipe (readFile ./gitlab-recipe);
        expected = "git+https://gitlab.com/joewreschnig/gitlab-ci-mode.git";
      };

      testSourcehut = {
        expr = flakeRefUrlFromMelpaRecipe (readFile ./data/recipes/sourcehut);
        expected = "sourcehut:~tomterl/fullframe";
      };

      testCodeberg = {
        expr = flakeRefUrlFromMelpaRecipe (readFile ./data/recipes/codeberg);
        expected = "git+https://codeberg.org/emacs-weirdware/scratch.git";
      };
    }
