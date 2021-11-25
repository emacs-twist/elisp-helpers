let
  pkgs = import <nixpkgs> { };
in
with (import ../default.nix { inherit pkgs; });
with builtins;
let
  defaultFilesSpec = import ../lib/defaultFilesSpec.nix;
in
pkgs.lib.runTests {
  recipe1 = {
    expr = parseRecipe (readFile ./recipe1);
    expected = {
      pname = "smex";
      repo = "nonsequitur/smex";
      fetcher = "github";
      files = null;
    };
  };

  recipe2 = {
    expr = parseRecipe (readFile ./recipe2);
    expected = {
      pname = "mypackage";
      repo = "someuser/mypackage";
      fetcher = "github";
      files = [ "mypackage.el" ];
    };
  };

  recipe3 = {
    expr = parseRecipe (readFile ./recipe3);
    expected = {
      pname = "flymake-perlcritic";
      repo = "illusori/emacs-flymake-perlcritic";
      fetcher = "github";
      files = [ "*.el" [ "bin" "bin/flymake_perlcritic" ] ];
    };
  };

  recipe4 = {
    expr = parseRecipe (readFile ./recipe4);
    expected = {
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

  recipe5 = {
    expr = parseRecipe (readFile ./recipe5);
    expected = {
      fetcher = "git";
      url = "https://framagit.org/steckerhalter/discover-my-major.git";
    };
  };

  expandResult = {
    expr = expandPackageFiles ./. defaultFilesSpec;
    expected = [
      "hello.el"
      "hello2.el"
      "doc/hello.info"
    ];
  };

  nestedExpansion1 = {
    expr = expandPackageFiles ./nested1 recipe3.files;
    expected = [
      "flymake-perlcritic.el"
      "bin/flymake_perlcritic"
    ];
  };

  nestedExpansion2 = {
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

  nestedExpansion3 = {
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

  nestedExpansion4 = {
    expr = expandPackageFiles ./org-starter recipe4.files;
    expected = [
      "org-starter-utils.el"
      "org-starter.el"
    ];
  };
}
