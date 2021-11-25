tests := $(wildcard test/*.nix)

test: $(tests)

test/%.nix: .PHONY
	nix-instantiate --eval --strict $@

.PHONY: tests
