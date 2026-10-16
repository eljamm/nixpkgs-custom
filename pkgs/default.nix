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
    # Automatic
    (callPackage ./by-name { })

    # Manual
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

    # Aliases
    {
      degit = lib.warnOnInstantiate "degit has been updated in Nixpkgs: https://github.com/NixOS/nixpkgs/pull/558892. Use that package instead of this one." pkgs.degit; # 2026-10-16
    }
  ]
)
