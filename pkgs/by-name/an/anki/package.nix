{
  pkgs,
  devLib,
}:

pkgs.symlinkJoin (finalAttrs: {
  pname = "anki";
  version = "26.09.3";

  paths = [
    pkgs.anki
  ];

  passthru = {
    inNixpkgsNewer = devLib.warnIfCond (devLib.isNewer pkgs.anki finalAttrs) ''
      You're using Anki `${finalAttrs.version}`, but a newer version is available in Nixpkgs: `${pkgs.anki.version}`.
    '';
  };
})
