{
  lib,
  pkgs,
  system,
  inputs,
  callPackage,
  ...
}:

lib.makeExtensible (
  self':
  with self';
  lib.mergeAttrsList [
    {
      # from https://github.com/NixOS/nixpkgs/pull/295587
      yuzu-packages = callPackage ./yuzu { };
      yuzu = yuzu-packages.mainline;
      yuzu-ea = yuzu-packages.early-access;
      yuzu-early-access = yuzu-packages.early-access;
      yuzu-mainline = yuzu-packages.mainline;

      # https://github.com/manic-systems/rom
      rom = inputs.rom.packages.${system}.default;

      # https://github.com/nix-community/rustowl-flake
      rustowl = inputs.rustowl.packages.${system}.default;
    }
    (callPackage ./by-name { })
  ]
)
