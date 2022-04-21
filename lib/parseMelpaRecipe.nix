{
  fromElisp,
  lib,
}: str:
with builtins;
with import ./utils.nix {inherit lib;}; let
  input = head (fromElisp.fromElisp str);
  props = plistToAlist (tail input);
  ename = head input;
in
  {
    inherit ename;
    pname = builtins.replaceStrings ["@"] ["at"] ename;
  }
  // alistToAttrs {emptyListToNull = true;} props
