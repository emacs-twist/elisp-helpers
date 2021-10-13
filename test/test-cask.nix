{ parseCask }:
with builtins;
let
  cask1 = parseCask (readFile ./Cask);
in
assert (cask1.package-file == "cask.el");
assert (cask1.sources == [ "gnu" "melpa" ]);
assert (cask1.files == null);
assert (map head cask1.development.dependencies
  == [ "f" "s" "dash" "ansi" "ecukes" "servant" "ert-runner" "el-mock" "noflet" "ert-async" "shell-split-string" ]);
null
