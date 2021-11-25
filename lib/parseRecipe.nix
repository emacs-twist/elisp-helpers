{ fromElisp, lib }: str:
with builtins;
with import ./utils.nix { inherit lib; };
let
  input = head (fromElisp.fromElisp str);
  props = plistToAlist (tail input);
  ename = head input;
in
{
  inherit ename;
  pname = builtins.replaceStrings [ "@" ] [ "at" ] ename;
  fetcher = safeHead (lookup ":fetcher" props);
  url = safeHead (lookup ":url" props);
  repo = safeHead (lookup ":repo" props);
  commit = safeHead (lookup ":commit" props);
  branch = safeHead (lookup ":branch" props);
  version-regexp = safeHead (lookup ":version-regexp" props);
  files = safeHead (lookup ":files" props);
}
