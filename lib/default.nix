{ pkgs ? import <nixpkgs> { }
, fromElisp
}:
let
  defaultFilesSpec = import ./defaultFilesSpec.nix;
in
rec {
  parseCask = pkgs.callPackage ./parseCask.nix {
    inherit fromElisp;
  };
  parseRecipe = pkgs.callPackage ./parseRecipe.nix {
    inherit fromElisp;
  };
  fetchFromRecipe = pkgs.callPackage ./fetchFromRecipe.nix {
    inherit parseRecipe;
  };
  fetchTreeFromRecipe = pkgs.callPackage ./fetchTreeFromRecipe.nix {
    inherit parseRecipe;
  };
  expandPackageFiles = pkgs.callPackage ./expandPackageFiles.nix {
    inherit defaultFilesSpec;
  };
}
