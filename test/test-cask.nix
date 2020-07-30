with (import ../default.nix { pkgs = import <nixpkgs> {}; });
let
  cask1 = parseCask (builtins.readFile ./Cask);
in
assert (cask1.package-file == "cask.el");
assert (cask1.sources == ["gnu" "melpa"]);
assert (cask1.files == null);
assert (builtins.map builtins.head cask1.development.dependencies
        == ["f" "s" "dash" "ansi" "ecukes" "servant" "ert-runner" "el-mock" "noflet" "ert-async" "shell-split-string"]);
null
