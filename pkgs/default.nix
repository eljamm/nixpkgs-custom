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

      inherit (inputs.rustowl.packages.${system}) rustowl;
    }
    (callPackage ./by-name { })
  ]
)
