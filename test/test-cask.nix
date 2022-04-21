let
  pkgs = import <nixpkgs> {};
in
  with (import ../default.nix {inherit pkgs;});
  with builtins; let
    cask1 = parseCask (readFile ./Cask);
  in
    pkgs.lib.runTests {
      testPackageFile = {
        expr = cask1.package-file;
        expected = "cask.el";
      };
      testSources = {
        expr = cask1.sources;
        expected = ["gnu" "melpa"];
      };
      testFiles = {
        expr = cask1.files;
        expected = null;
      };
      testDevDependencies = {
        expr = map head cask1.development.dependencies;
        expected = [
          "f"
          "s"
          "dash"
          "ansi"
          "ecukes"
          "servant"
          "ert-runner"
          "el-mock"
          "noflet"
          "ert-async"
          "shell-split-string"
        ];
      };
    }
