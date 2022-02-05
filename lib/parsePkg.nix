{ fromElisp, lib }:
str:
with builtins;
let
  inherit (import ./utils.nix { inherit lib; }) alistToAttrs plistToAlist;
  list = head (fromElisp.fromElisp str);
  rest = lib.pipe (lib.drop 5 list) [
    plistToAlist
    (alistToAttrs { emptyListToNull = true; })
  ];
in
if head list != "define-package"
then throw "A package description file does not start with define-package: ${str}"
else if length list < 5
then throw "A package description file does not specify dependencies: ${str}"
else
  rest
    //
  {
    ename = elemAt list 1;
    version = elemAt list 2;
    summary = elemAt list 3;
    packageRequires = lib.pipe (elemAt list 4) [
      (lib.flip elemAt 1)
      # I don't expect there is a package entry that lacks a version,
      # so I don't care emptyListToNull for now.
      (alistToAttrs { emptyListToNull = false; })
    ];
  }
