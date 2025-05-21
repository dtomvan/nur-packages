{
  description = "Packages from my personal dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        defaultNix = (import ./. { inherit pkgs; });
      in
      {
        packages = pkgs.lib.filterAttrs (name: p: pkgs.lib.isDerivation p) defaultNix;
        formatter = pkgs.nixfmt-tree;
      }
    );
}
