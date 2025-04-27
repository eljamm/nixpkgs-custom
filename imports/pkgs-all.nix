{ inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    let
      # from https://github.com/NixOS/nixpkgs/pull/295587
      yuzuPackages = pkgs.callPackage ../pkgs/yuzu { };
    in
    {
      packages = with pkgs; {
        vocabsieve = callPackage ../pkgs/vocabsieve/package.nix { };

        yuzu = yuzuPackages.mainline;
        yuzu-ea = yuzuPackages.early-access;
        yuzu-early-access = yuzuPackages.early-access;
        yuzu-mainline = yuzuPackages.mainline;

        inherit (inputs.rustowl.packages.${system}) rustowl;
      };

      checks = lib.filterAttrs (_: v: !v.meta.broken or false) self'.packages;
    };
}
