# 
#
# Note that this works only Nix 2.4 or later.
#
# This doesn't work in pure evaluation.
{ lib }: package:
with builtins;
let
  inherit (package) fetcher;
  path = split "/" package.repo;
  owner = elemAt path 0;
  repo = elemAt path 2;
  repoAttrs = lib.filterAttrs (_: v: v != null) {
    rev = package.commit;
    ref = package.branch;
  };
in
if fetcher == "github"
then
  fetchTree
    ({
      type = "github";
      inherit owner repo;
    } // repoAttrs)
else if fetcher == "gitlab"
then
  fetchTree
    ({
      type = "gitlab";
      inherit owner repo;
    } // repoAttrs)
else if fetcher == "git"
then
  fetchTree
    ({
      type = "git";
      inherit (package) url;
    } // repoAttrs)
else throw "Unsupported fetcher type: ${fetcher}"
