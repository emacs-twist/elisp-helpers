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
    (
      let
        lib = nixpkgs.lib;
        fromElisp = (import inputs.fromElisp) { pkgs = { inherit lib; }; };
      in
      {
        lib = import ./lib {
          inherit fromElisp;
          inherit (nixpkgs) lib;
        };
      }
    )
    //
    (flake-utils.lib.eachSystem
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
        in
        {
          checks = ({
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                nixpkgs-fmt.enable = true;
                nix-linter.enable = true;
              };
            };
          });
          devShell = pkgs.mkShell {
            buildInputs = [
              pkgs.gnumake
            ];
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
        }
      ));
}
