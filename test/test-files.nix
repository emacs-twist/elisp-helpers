let
  pkgs = import <nixpkgs> { };
in
with (import ../default.nix { inherit pkgs; });
with builtins;
let
  defaultFilesSpec = import ../lib/defaultFilesSpec.nix;

  recipe3 = parseMelpaRecipe (readFile ./recipe3);
  recipe4 = parseMelpaRecipe (readFile ./recipe4);
in
pkgs.lib.runTests {
  testExpandResult = {
    expr = expandMelpaRecipeFiles ./. defaultFilesSpec;
    expected = [
      "hello.el"
      "hello2.el"
      "doc/hello.info"
    ];
  };

  testNestedExpansion1 = {
    expr = expandMelpaRecipeFiles ./nested1 recipe3.files;
    expected = [
      "flymake-perlcritic.el"
      "bin/flymake_perlcritic"
    ];
  };

  testNestedExpansion2 = {
    expr = expandMelpaRecipeFiles ./nested2
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
    expr = expandMelpaRecipeFiles ./pony-mode
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
    expr = expandMelpaRecipeFiles ./org-starter recipe4.files;
    expected = [
      "org-starter-utils.el"
      "org-starter.el"
    ];
  };
}
