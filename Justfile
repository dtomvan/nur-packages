alias check := default

default: check-flake check-nur-eval check-formatting build-test

check-flake:
    nix flake check

check-nur-eval:
    nix run .#check-nur-eval

check-formatting:
    nix fmt -- --ci

build-test:
    nix shell nixpkgs#nix-output-monitor --command nom-build ci.nix -A buildPkgs
