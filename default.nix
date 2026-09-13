{
  self ? import ./dev/import-flake.nix { src = ./.; },
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config = {
      allowBroken = true;
    };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
lib.makeScope pkgs.newScope (
  self': with self'; {
    inherit
      lib
      pkgs
      self
      system
      inputs
      ;

    devLib = callPackage ./dev/lib.nix { };
    format = callPackage ./dev/formatter.nix { };
    customPkgs = lib.filterAttrs (n: v: lib.isDerivation v) (callPackage ./pkgs { });
    devShells.default = pkgs.mkShellNoCC {
      packages = [
        format.formatter
        pkgs.pinact # pin GH actions
      ];
    };

    overlays.default = final: prev: customPkgs;

    flake.perSystem = {
      inherit devShells;
      inherit (format) formatter;
      packages = customPkgs;
      checks = lib.filterAttrs (_: v: !v.meta.broken or false) flake.perSystem.packages;
      legacyPackages = customPkgs;
    };
    flake.systemAgnostic = {
      inherit overlays;
    };
  }
)
