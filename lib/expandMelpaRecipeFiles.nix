{ lib, defaultFilesSpec }:
with builtins;
with import ./utils.nix { inherit lib; };
let
  globToRegex = replaceStrings [ "?" "*" "." ] [ "." ".*" "\\." ];

  expandDefaults = initialSpec:
    if initialSpec == null then
      defaultFilesSpec
    else if head initialSpec == ":defaults" then
      defaultFilesSpec ++ tail initialSpec
    else
      initialSpec;

  globDir = prefix: dir: pattern:
    let
      subdir = dirOf pattern;
      subdirAsPath = dir + "/${subdir}";
    in
    if subdir == "." || prefix == subdir + "/"
    then
      lib.pipe (readDir dir) [
        attrNames
        (map (file: prefix + file))
        (filter (file: match (globToRegex pattern) file != null))
      ]
    else if ! pathExists subdirAsPath
    then [ ]
    else expandPackageFiles_ (prefix + "${subdir}/") subdirAsPath [ pattern ];

  go = prefix: dir: acc: entry:
    # If :exclude is specified, directories are scanned multiple times. I don't
    # think it is ideal for performance, but I don't know how to prevent it,
    # especially if a user spec is merged with the defaults. It may not be a
    # practical issue.
    if isList entry && head entry == ":exclude"
    then lib.subtractLists (expandPackageFiles_ prefix dir (tail entry)) acc
    else if isString entry
    then
      acc ++ globDir prefix dir entry
    else
      acc ++
      expandPackageFiles_ (prefix + "${head entry}/") (dir + "/${head entry}") (tail entry);

  expandPackageFiles_ = prefix: dir: foldl' (go prefix dir) [ ];
in
dir: initialSpec:
expandPackageFiles_ "" dir (expandDefaults initialSpec)
