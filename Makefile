test-cask:
	nix-instantiate --eval --strict -E 'import ./test/test-cask.nix'
.PHONY: test-cask
