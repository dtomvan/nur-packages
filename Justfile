alias check := default

default: check-flake check-nur-eval check-formatting

check-flake:
    nix flake check

check-nur-eval:
    nix run .#check-nur-eval

check-formatting:
    nix fmt -- --ci
