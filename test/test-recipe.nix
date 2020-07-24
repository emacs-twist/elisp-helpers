with (import ../default.nix { pkgs = import <nixpkgs> {}; });
let
  recipe1 = parseRecipe (builtins.readFile ./recipe1);
  recipe2 = parseRecipe (builtins.readFile ./recipe2);
  recipe3 = parseRecipe (builtins.readFile ./recipe3);
  expandResult = expandPackageFiles ./. defaultFilesSpec;
  nestedExpansion1 = expandPackageFiles ./nested1 recipe3.files;
  nestedExpansion2 = expandPackageFiles ./nested2
    [
      "*.el"
      [
        "snippets"
        [ "html-mode" "snippets/html-mode/*" ]
        [ "python-mode" "snippets/python-mode/*" ]
      ]
    ];
  nestedExpansion3 = expandPackageFiles ./pony-mode
    [
      "src/*.el"
      "snippets"
    ];
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
  assert (recipe2.files == [ "mypackage.el" ]);
  # recipe 3
  assert (recipe3.pname == "flymake-perlcritic");
  assert (recipe3.repo == "illusori/emacs-flymake-perlcritic");
  assert (recipe3.fetcher == "github");
  assert (recipe3.files == [ "*.el" [ "bin" "bin/flymake_perlcritic" ] ]);
  # expanding
  assert (expandResult == [ "hello.el" "hello2.el" "doc/hello.info" ]);
  assert (nestedExpansion1 == [ "flymake-perlcritic.el" "bin/flymake_perlcritic" ]);
  assert (nestedExpansion2 == [ "snippets/html-mode/1" "snippets/html-mode/2" "snippets/python-mode/def" "snippets/python-mode/while" ]);
  assert (nestedExpansion3 == [ "src/pony-mode.el" "src/pony-tpl.el" "snippets" ]);
  null
