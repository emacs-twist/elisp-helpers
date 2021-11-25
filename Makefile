tests := $(wildcard test/*.nix)

test: $(tests)

test/%.nix: .PHONY
	nix-instantiate --eval --strict --json $@ | jq

.PHONY: tests
