{
  pkgs,
  devLib,
}:

pkgs.symlinkJoin (finalAttrs: {
  pname = "digikam";
  version = "9.2.0";

  paths = [
    (pkgs.callPackage ./nixpkgs-pr-593786.nix { })
  ];

  passthru = {
    inNixpkgsNewer = devLib.warnIfCond (devLib.isNewer pkgs.anki finalAttrs) ''
      You're using Digikam `${finalAttrs.version}`, but a newer version is available in Nixpkgs: `${pkgs.digikam.version}`.
    '';
  };
})
