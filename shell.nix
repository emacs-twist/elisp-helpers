let
  pkgs = import <nixpkgs> {};
  pre-commit-check =
    (import ./default.nix { inherit pkgs; }).pre-commit-check.shellHook;
in
pkgs.mkShell { shellHook = pre-commit-check; }
