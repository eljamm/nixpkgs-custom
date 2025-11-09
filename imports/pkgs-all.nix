{ inputs, ... }:
{
  perSystem =
    {
      lib,
      self',
      default,
      ...
    }:
    {
      packages = lib.filterAttrs (n: v: lib.isDerivation v) default.packages;
      legacyPackages = lib.filterAttrs (n: v: lib.isDerivation v) default.packages;
      checks = lib.filterAttrs (_: v: !v.meta.broken or false) self'.packages;
    };
}
