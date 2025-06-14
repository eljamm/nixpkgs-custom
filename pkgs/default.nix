{
  lib,
  pkgs,
  system,
  sources,
}:
lib.makeScope pkgs.newScope (
  self: with self; {
    callPackage = self.newScope { };

    vocabsieve = callPackage ./vocabsieve/package.nix { };

    # from https://github.com/NixOS/nixpkgs/pull/295587
    yuzu-packages = callPackage ./yuzu { };
    yuzu = yuzu-packages.mainline;
    yuzu-ea = yuzu-packages.early-access;
    yuzu-early-access = yuzu-packages.early-access;
    yuzu-mainline = yuzu-packages.mainline;

    inherit (sources.rustowl.packages.${system}) rustowl;
  }
)
