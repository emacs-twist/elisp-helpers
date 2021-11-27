{ fromElisp, lib }: str:
with builtins;
with import ./utils.nix { inherit lib; };
let
  toplevels = fromElisp.fromElisp str;
  attrs = alistToAttrs { emptyListToNull = true; } toplevels;
  dependsOn = xs: lib.pipe xs [
    (filter (x: head x == "depends-on"))
    (map tail)
  ];
  lookup = key: xs:
    let
      found = filter (x: head x == key) xs;
    in
    if length found > 0 then tail (head found) else null;
in
(lib.filterAttrs (key: _: key != "source") attrs)
  //
{
  dependencies = dependsOn toplevels;
  development = {
    dependencies = dependsOn (lookup "development" toplevels);
  };
  files = lookup "files" toplevels;
  sources = lib.pipe toplevels [
    (filter (x: head x == "source"))
    (map (xs: head (tail xs)))
  ];
}
