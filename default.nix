{ pkgs ? import <nixpkgs> {} }:
with builtins;
let
  sources = import ./nix/sources.nix;
  fromElisp = import sources.fromElisp { inherit pkgs; };
  lookup = key: xs:
    let match = filter (x: head x == key) xs;
    in if length match > 0
       then tail (head match)
       else null;
  select = key: xs:
    if xs == null
    then []
    else map tail (filter (x: head x == key) xs);
  safeHead = xs: if isList xs && length xs > 0 then head xs else null;
  plistToAlist = xs:
    if length xs > 0
    then [(pkgs.lib.take 2 xs)] ++ (plistToAlist (pkgs.lib.drop 2 xs))
    else [];
in
{
  # Parse a Cask file.
  # See https://cask.readthedocs.io/en/latest/guide/dsl.html
  parseCask = str:
    let
      input = fromElisp.fromElisp str;
      development = lookup "development" input;
    in
      {
        # Package metadata
        package = lookup "package" input;
        package-file = safeHead (lookup "package-file" input);
        package-descriptor = safeHead (lookup "package-descriptor" input);
        # Package contents
        files = lookup "files" input;
        dependencies = select "depends-on" input;
        development = {
          dependencies = select "depends-on" development;
        };
        sources = map head (select "source" input);
      };

  parseRecipe = str:
    let
      input = head (fromElisp.fromElisp str);
      props = plistToAlist (tail input);
    in
      {
        pname = head input;
        fetcher = safeHead (lookup ":fetcher" props);
        url = null;
        repo = safeHead (lookup ":repo" props);
        commit = safeHead (lookup ":commit" props);
        branch = safeHead (lookup ":branch" props);
        version-regexp = safeHead (lookup ":version-regexp" props);
        files = safeHead (lookup ":files" props);
      };

  expandPackageFiles = dir: spec: null;
}
