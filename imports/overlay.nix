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
      };

      overlayAttrs = config.packages;

      # TODO: refactor
      formatter =
        let
          default = import ../default.nix { inherit self system; };
        in
        default.formatter;
    };
}
