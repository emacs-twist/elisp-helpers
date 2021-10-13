# Expand :files spec in a MELPA recipe.
# dir is a path to a directory (usually the root of a project),
# and initialSpec is a list of specs.
#
# If null is given as initialSpec, defaultFilesSpec is used.
{ lib, defaultFilesSpec }:
with builtins;
with import ./utils.nix { inherit lib; };
let
  expandPackageFiles_ = prefix: dir: initialSpec:
    let
      files =
        lib.mapAttrsToList (n: _v: n) (readDir dir);
      expandWildcards = pattern:
        let
          regex = replaceStrings [ "?" "*" "." ] [ "." ".*" "\\." ] pattern;
          filesWithDirs = map (file: prefix + file) files;
        in
        filter (file: match regex file != null) filesWithDirs;
      go = filelist: entry:
        if isString entry then
          let
            subdir = dirOf entry;
            subdirAsPath = dir + "/${subdir}";
            suc =
              if subdir == "." || prefix == subdir + "/"
              then expandWildcards entry
              else if pathExists subdirAsPath
              then expandPackageFiles_ (prefix + "${subdir}/") subdirAsPath [ entry ]
              else [ ];
          in
          filelist ++ suc
        else
          let
            key = head entry;
          in
          if key == ":exclude" then
            lib.subtractLists (expandPackageFiles_ prefix dir (tail entry)) filelist
          else
            filelist ++ (
              expandPackageFiles_ (prefix + "${key}/") (dir + "/${key}") (tail entry)
            );
      concreteList =
        if initialSpec == null then
          defaultFilesSpec
        else if head initialSpec == ":defaults" then
          defaultFilesSpec ++ tail initialSpec
        else
          initialSpec;
    in
    foldl' go [ ] concreteList;
in
expandPackageFiles_ ""
