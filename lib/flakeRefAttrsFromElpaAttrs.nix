{ lib }: { preferReleaseBranch ? false }: spec @ { url, ... }:
with builtins;
let
  vcAttrs = lib.filterAttrs (_: v: v != null) {
    ref =
      if preferReleaseBranch
      then spec.release-branch or spec.branch or null
      else spec.branch or null;
  };
  githubPath = lib.pipe url [
    (lib.removePrefix "https://github.com/")
    (lib.removeSuffix ".git")
    (split "/")
    (filter isString)
  ];
in
if url == null
then throw "url is null"
else if lib.hasPrefix "https://github.com/" url
then
  (vcAttrs // {
    type = "github";
    owner = elemAt githubPath 0;
    repo = elemAt githubPath 1;
  })
else if lib.hasPrefix "hg::" url
then
  (vcAttrs // {
    type = "mercurial";
    url = lib.removePrefix "hg::" url;
  })
else
  (vcAttrs // {
    type = "git";
    inherit url;
  })
