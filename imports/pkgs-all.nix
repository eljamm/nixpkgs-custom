{ ... }:
{

  perSystem =
    { pkgs, ... }:
    {
      packages = with pkgs; {
        vocabsieve = libsForQt5.callPackage ../pkgs/vocabsieve/package.nix { };
      };
    };
}
