{ self, inputs, ... }:

{
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
    inputs.pkgs-by-name-for-flake-parts.flakeModule
  ];

  perSystem =
    {
      config,
      system,
      default,
      ...
    }:
    {
      _module.args = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ ];
          config = {
            allowBroken = true;
          };
        };
        default = import ../default.nix { inherit self system; };
      };

      overlayAttrs = config.packages;

      formatter = default.formatter;
    };
}
