{ fromElisp, lib }: str:
with builtins;
with import ./utils.nix { inherit lib; };
lib.pipe str [
  fromElisp.fromElisp
  head
  (map (tree: {
    name = head tree;
    # value = (tail tree);
    value =
      alistToAttrs { emptyListToNull = true; }
        (plistToAlist (tail tree));
  }))
  listToAttrs
]
