{ flakeRef }:
with builtins;
assert ((flakeRef (readFile ./recipe1)) == "github:nonsequitur/smex");
assert ((flakeRef (readFile ./recipe2)) == "github:someuser/mypackage");
assert ((flakeRef (readFile ./recipe5)) ==
  "git+https://framagit.org/steckerhalter/discover-my-major.git");
assert ((flakeRef (readFile ./recipe6)) == "github:jcaw/elnode/melpa");
assert ((flakeRef (readFile ./recipe7)) ==
  "git://github.com/edolstra/dwarffs");
assert ((flakeRef (readFile ./gitlab-recipe)) ==
  "git+https://gitlab.com/joewreschnig/gitlab-ci-mode");
null
