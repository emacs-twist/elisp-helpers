{ pkgs ? import <nixpkgs> {} }:
let
  nix-pre-commit-hooks = import (import ./sources.nix)."pre-commit-hooks.nix";
  gitignore = import (import ./sources.nix)."gitignore.nix" { inherit (pkgs) lib; };
in
{
  # Format and lint code via pre-commit Git hook.
  # See ../shell.nix
  pre-commit-check = nix-pre-commit-hooks.run {
    src = gitignore.gitignoreSource ./.;
    hooks = {
      nixpkgs-fmt.enable = true;
      nix-linter.enable = true;
    };
  };
}
