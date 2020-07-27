{ _pkgs ? import <nixpkgs> {} }:
let
  nix-pre-commit-hooks = import (import ./sources.nix)."pre-commit-hooks.nix";
in
{
  # Format and lint code via pre-commit Git hook.
  # See ../shell.nix
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      nixpkgs-fmt.enable = true;
      nix-linter.enable = true;
    };
  };
}
