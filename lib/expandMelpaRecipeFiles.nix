{ lib }: { defaultFilesSpec }:
with builtins;
with import ./utils.nix { inherit lib; };
root:
let
  globToRegex = replaceStrings [ "?" "*" "." ] [ "." ".*" "\\." ];

  pathRegexp = "(.+)/([^/]+)";

  breakPath = string:
    if match pathRegexp string == null
    then [ "" string ]
    else match pathRegexp string;

  readDirIfExists = path:
    if pathExists path
    then attrNames (readDir path)
    else [ ];

  addDirContents = dir: prev:
    if hasAttr dir prev
    then prev
    else if prev == ""
    then prev // {
      "" = readDirIfExists root;
    }
    else prev // {
      ${dir} = readDirIfExists (root + "/${dir}");
    };

  addTrailing = dir:
    if dir == ""
    then dir
    else dir + "/";

  matchingPattern = pattern: filename:
    match (globToRegex pattern) filename != null;

  generateFileMappings = prefix: acc: dir: pattern:
    lib.pipe acc.${dir} [
      (filter (matchingPattern pattern))
      (map (filename: {
        name = (addTrailing dir) + filename;
        value = (addTrailing prefix)
          + builtins.replaceStrings [ ".el.in" ] [ ".el" ] filename;
      }))
      listToAttrs
    ];

  addFromPattern = prefix: prev: dirAndPath: rec {
    directories = addDirContents (elemAt dirAndPath 0) prev.directories;
    result =
      prev.result
      //
      generateFileMappings prefix directories
        (elemAt dirAndPath 0)
        (elemAt dirAndPath 1);
  };

  go = prefix: acc: entry:
    if isString entry
    then addFromPattern prefix acc (breakPath entry)
    else if isList entry && head entry == ":exclude"
    then acc // {
      result = lib.filterAttrs
        (name: _:
          ! any (pattern: matchingPattern pattern name) (tail entry)
        )
        acc.result;
    }
    else if isList entry
    then foldl' (go (addTrailing prefix + head entry)) acc (tail entry)
    else throw "Entry has an unsupported type: ${toJSON entry}";
in
initialSpec:
(foldl'
  (go "")
  {
    directories = { };
    result = { };
  }
  (if initialSpec == null
  then defaultFilesSpec
  else if head initialSpec == ":defaults"
  then defaultFilesSpec ++ tail initialSpec
  else initialSpec)
).result
