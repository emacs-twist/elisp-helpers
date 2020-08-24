with (import ../default.nix { pkgs = import <nixpkgs> {}; });
let
  cask1 = parseCask (builtins.readFile ./Cask);
  cask2 = parseCask ''
    (source gnu)
    (source melpa)

    (package "xwwp" "0.1" "xwidget-webkit enhancement.")
    (package-file "xwwp.el")

    (development
     (depends-on "ert-runner"
                 :git "https://github.com/canatella/ert-runner.el"
                 :branch "win-fix"
                 :files (:defaults ("reporters" "reporters/*") ("bin" "bin/*")))
     (depends-on "ert-async")
     (depends-on "package-lint")
     (depends-on "with-simulated-input")
     (depends-on "ivy")
     (depends-on "helm"))
  '';
in
  assert (cask1.package-file == "cask.el");
  assert (cask1.sources == [ "gnu" "melpa" ]);
  assert (cask1.files == null);
  assert (
    builtins.map builtins.head cask1.development.dependencies
    == [ "f" "s" "dash" "ansi" "ecukes" "servant" "ert-runner" "el-mock" "noflet" "ert-async" "shell-split-string" ]
  );
  assert (cask2.package == [ "xwwp" "0.1" "xwidget-webkit enhancement." ]);
  assert (
    builtins.map builtins.head cask2.development.dependencies
    == [ "ert-runner" "ert-async" "package-lint" "with-simulated-input" "ivy" "helm" ]
  );
  assert (
    builtins.hasAttr "ert-async" cask2.overrideRecipes
    == false
  );
  assert (
    cask2.overrideRecipes.ert-runner.pname
    == "ert-runner"
  );
  assert (
    cask2.overrideRecipes.ert-runner.git
    == "https://github.com/canatella/ert-runner.el"
  );
  assert (
    cask2.overrideRecipes.ert-runner.branch
    == "win-fix"
  );
  assert (
    cask2.overrideRecipes.ert-runner.files
    == [ ":defaults" [ "reporters" "reporters/*" ] [ "bin" "bin/*" ] ]
  );
  null
