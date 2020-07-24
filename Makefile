test: test-cask test-recipe
.PHONY: test

test-cask:
	nix-instantiate --eval --strict -E 'import ./test/test-cask.nix'
.PHONY: test-cask

test-recipe:
	nix-instantiate --eval --strict -E 'import ./test/test-recipe.nix'
.PHONY: test-recipe
