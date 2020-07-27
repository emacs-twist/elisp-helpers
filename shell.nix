{ pkgs ? import <nixpkgs> {} }:
let
  pre-commit-check =
    (import ./nix/hooks.nix { inherit pkgs; }).pre-commit-check.shellHook;
in
pkgs.mkShell { shellHook = pre-commit-check; }
