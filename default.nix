# This file remains for backward compatibility
{pkgs ? import <nixpkgs> {}}: let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);

  fromElispSrc = builtins.fetchTree lock.nodes.fromElisp.locked;

  fromElisp = import (fromElispSrc + "/default.nix") {inherit pkgs;};
in
  import ./lib {
    inherit (pkgs) lib;
    inherit fromElisp;
  }
