{
  description = "Emacs Lisp utilities for Nix";

  inputs = {
    fromElisp = {
      url = "github:talyz/fromElisp";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      lib = import ./lib {
        fromElisp = (import inputs.fromElisp) {
          pkgs = {
            inherit (nixpkgs) lib;
          };
        };
        inherit (nixpkgs) lib;
      };
    };
}
