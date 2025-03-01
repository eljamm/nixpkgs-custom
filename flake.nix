{
  description = "Custom Nixpkgs Repo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

    # fish: 4.0
    # https://github.com/NixOS/nixpkgs/pull/367229
    nixpkgs-fish.url = "github:NixOS/nixpkgs?ref=fish";
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      imports = with builtins; map (fn: ./imports/${fn}) (attrNames (readDir ./imports));
    };
}
