{
  description = "Packages from my personal dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/devshell.nix
        ./modules/eval-check.nix
        ./modules/formatter.nix
        ./modules/koil-test.nix
        ./modules/nixos.nix
        ./modules/packages.nix
        ./modules/systems.nix
      ];
    };
}
