{ ... }:
{
  perSystem =
    { pkgs, pkgsPatched, ... }:
    {
      packages = with pkgs; rec {
        vocabsieve = libsForQt5.callPackage ../pkgs/vocabsieve/package.nix { };

        # from https://github.com/NixOS/nixpkgs/pull/295587
        yuzuPackages = callPackage ../pkgs/yuzu { };
        yuzu = yuzuPackages.mainline;
        yuzu-ea = yuzuPackages.early-access;
        yuzu-early-access = yuzuPackages.early-access;
        yuzu-mainline = yuzuPackages.mainline;

        inherit (pkgsPatched) fish umu-launcher;
      };
    };
}
