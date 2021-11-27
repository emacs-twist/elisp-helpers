# A collection of utility functions
{ lib }:
with builtins;
let
  # Look up a key in an alist-like structure.
  lookup = key: xs:
    let
      found = filter (x: head x == key) xs;
    in
    if length found > 0 then tail (head found) else null;

  # Filter sublists whose head equals to key and return their tails.
  select = key: xs:
    if xs == null then [ ] else map tail (filter (x: head x == key) xs);

  # If a non-empty list is given, return its head. Otherwise return null.
  safeHead = xs: if isList xs && length xs > 0 then head xs else null;

  # Transform a flat list into a nested list
  plistToAlist = xs:
    if length xs == 0 then
      [ ]
    else
      [ (lib.take 2 xs) ] ++ plistToAlist (lib.drop 2 xs);

  alistToAttrs = { emptyListToNull }: xs:
    lib.pipe xs [
      (map (cell: {
        name = lib.removePrefix ":" (head cell);
        value =
          # There can be a plist where no value is provided for the final key,
          # which should be considered a nil value.
          #
          # This is valid in lisp, but there is a missing cell, so you have
          # to check it.
          if (length cell < 2) || (emptyListToNull && (elemAt cell 1) == [ ])
          then null
          else (elemAt cell 1);
      }))
      listToAttrs
    ];
in
{
  inherit lookup select safeHead plistToAlist alistToAttrs;
}
