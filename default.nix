{ pkgs ? import <nixpkgs> {} }:
with builtins;
let
  sources = import ./nix/sources.nix;
  fromElisp = import sources.fromElisp { inherit pkgs; };
  # Look up a key in an alist-like structure.
  lookup = key: xs:
    let
      match = filter (x: head x == key) xs;
    in
      if length match > 0 then tail (head match) else null;
  # Filter sublists whose head equals to key and return their tails.
  select = key: xs:
    if xs == null then [] else map tail (filter (x: head x == key) xs);
  # If a non-empty list is given, return its head. Otherwise return null.
  safeHead = xs: if isList xs && length xs > 0 then head xs else null;
  # Transform a flat list into a nested list
  plistToAlist = xs:
    if length xs > 0 then
      [ (pkgs.lib.take 2 xs) ] ++ (plistToAlist (pkgs.lib.drop 2 xs))
    else
      [];
  # pre-commit hook for development
  nix-pre-commit-hooks = import sources."pre-commit-hooks.nix";
in
rec {
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
        development = { dependencies = select "depends-on" development; };
        sources = map head (select "source" input);
      };

  # Parse a MELPA recipe.
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

  # Default :files spec.
  #
  # Based on package-build-default-files-spec in package-build.el.
  defaultFilesSpec = [
    "*.el"
    "*.el.in"
    "dir"
    "*.info"
    "*.texi"
    "*.texinfo"
    "doc/dir"
    "doc/*.info"
    "doc/*.texi"
    "doc/*.texinfo"
    [
      ":exclude"
      ".dir-locals.el"
      "test.el"
      "tests.el"
      "*-test.el"
      "*-tests.el"
    ]
  ];

  # Expand :files spec in a MELPA recipe.
  # dir is a path to a directory (usually the root of a project),
  # and initialSpec is a list of specs.
  #
  # If null is given as initialSpec, defaultFilesSpec is used.
  expandPackageFiles = dir: initialSpec:
    let
      filesInDir = dir:
        pkgs.lib.mapAttrsToList (n: _v: n)
          (pkgs.lib.filterAttrs (_n: v: v == "regular") (readDir dir));
      globToRegexp = replaceStrings [ "?" "*" "." ] [ "." ".*" "\\." ];
      prependSubdir = subdir: file: subdir + "/" + file;
      expandWildcards = dir: pattern:
        let
          files = filesInDir dir;
          regex = globToRegexp pattern;
        in
          filter (file: match regex file != null) files;
      go = subdir: filelist: entry:
        if isString entry then
          filelist ++ expandWildcards subdir entry
        else if head entry == ":exclude" then
          pkgs.lib.subtractLists (expandPackageFiles subdir (tail entry))
            filelist
        else
          filelist ++ (
            map (prependSubdir (head entry))
              (expandPackageFiles (subdir + "/${head entry}") (tail entry))
          );
      concreteList = if initialSpec == null then
        defaultFilesSpec
      else if head initialSpec == ":defaults" then
        defaultFilesSpec ++ tail initialSpec
      else
        initialSpec;
    in
      builtins.foldl' (go dir) [] concreteList;

  # Format and lint code via pre-commit Git hook.
  # See shell.nix
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      nixpkgs-fmt.enable = true;
      nix-linter.enable = true;
    };
  };
}
