tests := $(wildcard test/*.nix)

test: $(tests)

test/%.nix: .FORCE
	nix-instantiate --eval --strict --json $@ | jq

.PHONY: test

.FORCE:
