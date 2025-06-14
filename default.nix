let
  flake-inputs = import (
    fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0"
  );
  inherit (flake-inputs)
    import-flake
    ;
in
{
  self ? import-flake {
    src = ./.;
  },
  sources ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${sources.nixpkgs}/lib",
}:
rec {
  inherit
    lib
    pkgs
    system
    sources
    ;

  formatter = import ./dev/formatter.nix { inherit pkgs sources system; };

  shell = pkgs.mkShellNoCC {
    packages = [
      formatter
      pkgs.pinact # pin GH actions
    ];
  };

  packages = lib.makeScope pkgs.newScope (
    self: with self; {
      callPackage = self.newScope { };

      vocabsieve = callPackage ./pkgs/vocabsieve/package.nix { };

      # from https://github.com/NixOS/nixpkgs/pull/295587
      yuzu-packages = callPackage ./pkgs/yuzu { };
      yuzu = yuzu-packages.mainline;
      yuzu-ea = yuzu-packages.early-access;
      yuzu-early-access = yuzu-packages.early-access;
      yuzu-mainline = yuzu-packages.mainline;

      inherit (sources.rustowl.packages.${system}) rustowl;
    }
  );
}
