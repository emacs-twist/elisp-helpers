# Contributing Guide

This contributing guide is not finished, so it may lack certain required information.

## Formatting and linting

This project uses `nixpkgs-fmt` and `nix-linter` for formatting and checking Nix code.
You can set up a pre-commit hook for Git by running the following command:

```sh
nix develop
```

## Testing

Please run commands described in this section to check if your contribution
is correct.

First run:

```sh
nix flake check
```

If it prints a formatting error, you can fix it by trying to run `git commit`.

Also run:

```sh
nix-build test/impure-checks.nix
```

All of the commands should exit with 0.
