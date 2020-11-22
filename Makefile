test: test-cask test-recipe test-fetch
.PHONY: test

test-cask:
	nix-instantiate --eval --strict -E 'import ./test/test-cask.nix'
.PHONY: test-cask

test-recipe:
	nix-instantiate --eval --strict -E 'import ./test/test-recipe.nix'
.PHONY: test-recipe

test-fetch:
	nix-instantiate --eval --strict -E 'import ./test/test-fetch.nix'
.PHONY: test-fetch
