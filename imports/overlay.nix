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

      _module.args = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ ];
          config = { };
        };
      };

      overlayAttrs = config.packages;
    };
}
