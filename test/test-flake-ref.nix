{ flakeRefFromRecipe }:
with builtins;
assert ((flakeRefFromRecipe (readFile ./recipe1)) == "github:nonsequitur/smex");
assert ((flakeRefFromRecipe (readFile ./recipe2)) == "github:someuser/mypackage");
assert ((flakeRefFromRecipe (readFile ./recipe5)) ==
  "git+https://framagit.org/steckerhalter/discover-my-major.git");
assert ((flakeRefFromRecipe (readFile ./recipe6)) == "github:jcaw/elnode/melpa");
assert ((flakeRefFromRecipe (readFile ./recipe7)) ==
  "git://github.com/edolstra/dwarffs");
assert ((flakeRefFromRecipe (readFile ./gitlab-recipe)) ==
  "git+https://gitlab.com/joewreschnig/gitlab-ci-mode.git");
null
