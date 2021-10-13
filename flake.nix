{
  description = "Emacs Lisp utilities for Nix";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.fromElisp = {
    url = "github:talyz/fromElisp";
    flake = false;
  };
  inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks, ... }@inputs:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "i686-linux"
      ]
      (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          fromElisp = (import inputs.fromElisp) { inherit pkgs; };
        in
        {
          lib = import ./lib { inherit pkgs fromElisp; };
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = builtins.path {
                path = ./.;
                name = "nix-elisp-helpers";
              };
              hooks = {
                nixpkgs-fmt.enable = true;
                nix-linter.enable = true;
              };
            };
            pure = pkgs.callPackage ./test/pure-checks.nix {
              inherit (self.lib.${system}) parseCask parseRecipe expandPackageFiles;
            };
          };
          devShell = nixpkgs.legacyPackages.${system}.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
        }
      );
}