{ flakeRefUrlFromRecipe }:
with builtins;
assert ((flakeRefUrlFromRecipe (readFile ./recipe1)) == "github:nonsequitur/smex");
assert ((flakeRefUrlFromRecipe (readFile ./recipe2)) == "github:someuser/mypackage");
assert ((flakeRefUrlFromRecipe (readFile ./recipe5)) ==
  "git+https://framagit.org/steckerhalter/discover-my-major.git");
assert ((flakeRefUrlFromRecipe (readFile ./recipe6)) == "github:jcaw/elnode/melpa");
assert ((flakeRefUrlFromRecipe (readFile ./recipe7)) ==
  "git://github.com/edolstra/dwarffs");
assert ((flakeRefUrlFromRecipe (readFile ./gitlab-recipe)) ==
  "git+https://gitlab.com/joewreschnig/gitlab-ci-mode.git");
null
