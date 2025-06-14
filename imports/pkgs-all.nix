{ inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    {
      packages = lib.makeScope pkgs.newScope (
        self: with pkgs; {
          vocabsieve = callPackage ../pkgs/vocabsieve/package.nix { };

          # from https://github.com/NixOS/nixpkgs/pull/295587
          yuzu-packages = pkgs.callPackage ../pkgs/yuzu { };
          yuzu = self.yuzu-packages.mainline;
          yuzu-ea = self.yuzu-packages.early-access;
          yuzu-early-access = self.yuzu-packages.early-access;
          yuzu-mainline = self.yuzu-packages.mainline;

          inherit (inputs.rustowl.packages.${system}) rustowl;
        }
      );

      checks = lib.filterAttrs (_: v: !v.meta.broken or false) self'.packages;
    };
}
