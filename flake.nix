{
  description = "Custom Nixpkgs Repo";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable-small/nixexprs.tar.zst";
    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    rustowl.url = "github:nix-community/rustowl-flake";
    rustowl.inputs.nixpkgs.follows = "nixpkgs";
    rustowl.inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    rom.url = "github:manic-systems/rom";
    rom.inputs.nixpkgs.follows = "nixpkgs";
  };

  # import flake attributes from ./flake/default.nix
  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib)
        eachSystem
        eachSystemPassThrough
        ;

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      getDefault = system: (import ./. { inherit self inputs system; });
      importFlake = arg: system: (getDefault system).flake.${arg} or { };

      # independant of system (e.g. nixosModules)
      systemAgnosticFlake = eachSystemPassThrough systems (importFlake "systemAgnostic");

      # depends on system (e.g. packages.x86_64-linux)
      perSystemFlake = eachSystem systems (importFlake "perSystem");
    in
    systemAgnosticFlake // perSystemFlake;
}
