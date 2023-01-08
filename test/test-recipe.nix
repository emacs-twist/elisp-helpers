let
  pkgs = import <nixpkgs> {};
in
  with (import ../default.nix {inherit pkgs;});
  with builtins; let
    recipe1 = parseMelpaRecipe (readFile ./recipe1);
    recipe2 = parseMelpaRecipe (readFile ./recipe2);
    recipe3 = parseMelpaRecipe (readFile ./recipe3);
    recipe4 = parseMelpaRecipe (readFile ./recipe4);
    recipe5 = parseMelpaRecipe (readFile ./recipe5);
    recipeGitlab = parseMelpaRecipe (readFile ./gitlab-recipe);

    excludeNulls = pkgs.lib.filterAttrs (_: val: val != null);
  in
    pkgs.lib.runTests {
      testRecipe1 = {
        expr = excludeNulls recipe1;
        expected = {
          ename = "smex";
          pname = "smex";
          repo = "nonsequitur/smex";
          fetcher = "github";
        };
      };

      testRecipe2 = {
        expr = excludeNulls recipe2;
        expected = {
          ename = "mypackage";
          pname = "mypackage";
          repo = "someuser/mypackage";
          fetcher = "github";
          files = ["mypackage.el"];
        };
      };

      testRecipe3 = {
        expr = excludeNulls recipe3;
        expected = {
          ename = "flymake-perlcritic";
          pname = "flymake-perlcritic";
          repo = "illusori/emacs-flymake-perlcritic";
          fetcher = "github";
          files = ["*.el" ["bin" "bin/flymake_perlcritic"]];
        };
      };

      testRecipe4 = {
        expr = excludeNulls recipe4;
        expected = {
          ename = "org-starter";
          pname = "org-starter";
          repo = "akirak/org-starter";
          fetcher = "github";
          files = [
            ":defaults"
            [
              ":exclude"
              "counsel-org-starter.el"
              "helm-org-starter.el"
              "org-starter-swiper.el"
              "org-starter-extras.el"
            ]
          ];
        };
      };

      testRecipe5 = {
        expr = excludeNulls recipe5;
        expected = {
          ename = "discover-my-major";
          pname = "discover-my-major";
          fetcher = "git";
          url = "https://framagit.org/steckerhalter/discover-my-major.git";
        };
      };

      testGitlabRecipe = {
        expr = excludeNulls recipeGitlab;
        expected = {
          ename = "gitlab-ci-mode";
          pname = "gitlab-ci-mode";
          fetcher = "gitlab";
          repo = "joewreschnig/gitlab-ci-mode";
        };
      };
    }
