let
  pkgs = import <nixpkgs> { };
in
with (import ../default.nix { inherit pkgs; });
with builtins;
let
  defaultFilesSpec = import ../lib/defaultFilesSpec.nix;

  recipe1 = parseRecipe (readFile ./recipe1);
  recipe2 = parseRecipe (readFile ./recipe2);
  recipe3 = parseRecipe (readFile ./recipe3);
  recipe4 = parseRecipe (readFile ./recipe4);
  recipe5 = parseRecipe (readFile ./recipe5);

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
      files = [ "mypackage.el" ];
    };
  };

  testRecipe3 = {
    expr = excludeNulls recipe3;
    expected = {
      ename = "flymake-perlcritic";
      pname = "flymake-perlcritic";
      repo = "illusori/emacs-flymake-perlcritic";
      fetcher = "github";
      files = [ "*.el" [ "bin" "bin/flymake_perlcritic" ] ];
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

  testExpandResult = {
    expr = expandPackageFiles ./. defaultFilesSpec;
    expected = [
      "hello.el"
      "hello2.el"
      "doc/hello.info"
    ];
  };

  testNestedExpansion1 = {
    expr = expandPackageFiles ./nested1 recipe3.files;
    expected = [
      "flymake-perlcritic.el"
      "bin/flymake_perlcritic"
    ];
  };

  testNestedExpansion2 = {
    expr = expandPackageFiles ./nested2
      [
        "*.el"
        [
          "snippets"
          [ "html-mode" "snippets/html-mode/*" ]
          [ "python-mode" "snippets/python-mode/*" ]
        ]
      ];
    expected = [
      "snippets/html-mode/1"
      "snippets/html-mode/2"
      "snippets/python-mode/def"
      "snippets/python-mode/while"
    ];
  };

  testNestedExpansion3 = {
    expr = expandPackageFiles ./pony-mode
      [
        "src/*.el"
        "snippets"
      ];
    expected = [
      "src/pony-mode.el"
      "src/pony-tpl.el"
      "snippets"
    ];
  };

  testNestedExpansion4 = {
    expr = expandPackageFiles ./org-starter recipe4.files;
    expected = [
      "org-starter-utils.el"
      "org-starter.el"
    ];
  };
}
