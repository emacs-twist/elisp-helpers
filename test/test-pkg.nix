let
  pkgs = import <nixpkgs> { };
  inherit (import ../default.nix { inherit pkgs; }) parsePkg;
in
pkgs.lib.runTests {
  testPkg = {
    expr = parsePkg ''
      (define-package "heaven-sent" "2.9.11"
        "An infinite loop of tortures"
        '((doctor "12.0")
          (veil "1.0"))
        :extras "Clara")
    '';
    expected = {
      ename = "heaven-sent";
      version = "2.9.11";
      summary = "An infinite loop of tortures";
      packageRequires = {
        doctor = "12.0";
        veil = "1.0";
      };
      extras = "Clara";
    };
  };
}
