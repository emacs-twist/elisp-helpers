{ fromElisp, lib }: str:
with builtins;
with import ./utils.nix { inherit lib; };
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
}
