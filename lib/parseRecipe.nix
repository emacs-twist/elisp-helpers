{ fromElisp, lib }: str:
with builtins;
with import ./utils.nix { inherit lib; };
let
  input = head (fromElisp.fromElisp str);
  props = plistToAlist (tail input);
in
{
  pname = head input;
  fetcher = safeHead (lookup ":fetcher" props);
  url = safeHead (lookup ":url" props);
  repo = safeHead (lookup ":repo" props);
  commit = safeHead (lookup ":commit" props);
  branch = safeHead (lookup ":branch" props);
  version-regexp = safeHead (lookup ":version-regexp" props);
  files = safeHead (lookup ":files" props);
}
