# This file remains for backward compatibility
{ pkgs ? import <nixpkgs> { } }:
let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);

  fromElispSrc = pkgs.fetchFromGitHub {
    inherit (lock.nodes.fromElisp.locked) owner repo rev;
    sha256 = lock.nodes.fromElisp.locked.narHash;
  };

  fromElisp = import (fromElispSrc + "/default.nix") { inherit pkgs; };
in
import ./lib {
  inherit pkgs fromElisp;
}
