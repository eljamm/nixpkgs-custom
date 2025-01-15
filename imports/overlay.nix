{ inputs, ... }:

{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    inputs.pkgs-by-name-for-flake-parts.flakeModule
  ];

  perSystem =
    {
      config,
      system,
      ...
    }:
    {

      _module.args = rec {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.self.overlays.default ];
          config = { };
        };

        pkgsPatches = {
          inherit (inputs.nixpkgs-fish.legacyPackages.${system}) fish;
        };

        pkgsPatched = import (pkgs.applyPatches {
          name = "nixpkgs-patched-${inputs.nixpkgs.shortRev}";
          src = inputs.nixpkgs;
          patches = [
            inputs.patches-umu-369259
          ];
        }) { inherit system; };
      };

      overlayAttrs = config.packages;
    };
}
