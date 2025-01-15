{
  description = "Custom Nixpkgs Repo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

    # fish: 3.7.3 -> 4.0b1
    # https://github.com/NixOS/nixpkgs/pull/367229
    nixpkgs-fish.url = "github:NixOS/nixpkgs?ref=fish";

    ## Patches ##
    # umu-launcher: init
    patches-umu-369259 = {
      url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/369259.patch";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;

      imports = with builtins; map (fn: ./imports/${fn}) (attrNames (readDir ./imports));
    };
}
