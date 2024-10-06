{
  description = "Emacs Lisp utilities for Nix";

  inputs = {
    fromElisp = {
      url = "github:talyz/fromElisp";
      flake = false;
    };
  };

  outputs =
    { ... }@inputs:
    {
      lib = {
        makeLib =
          { lib }:
          import ./lib {
            fromElisp = (import inputs.fromElisp) {
              pkgs = {
                inherit lib;
              };
            };
            inherit lib;
          };

      };
    };
}
