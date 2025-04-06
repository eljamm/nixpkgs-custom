# My Custom Nixpkgs Overlay

This repository is built on the [my-own-nixpkgs](https://github.com/drupol/my-own-nixpkgs) template and serves as a collection for my custom Nix expressions, structured in a similar way as `nixpkgs`.

## Usage

Add the following to your `nix` flake file to include this repository as an input:

```nix
inputs = {
  nixpkgs-custom = {
    url = "github:eljamm/nixpkgs-custom";
    inputs.nixpkgs.follows = "nixpkgs";
    # Uncomment this if your project uses flake-parts:
    # inputs.flake-parts.follows = "flake-parts"; 
  };
};
```

Next, either integrate the packages using an `overlay` or a `custom package set`.

### Integrating Packages as an Overlay

To use this repository in another project as an overlay, follow these steps:

1. **Include the Overlay in `pkgs`**:

    When constructing `pkgs`, include the overlay as follows:

    ```nix
    pkgs = import inputs.nixpkgs {
      overlays = [
        inputs.nixpkgs-custom.overlays.default
      ];
    };
    ```

1. **Use Your Packages**:

    Access the packages in this project like this:

    ```nix
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.hello
        pkgs.custom-pkg
      ];
    }
    ```

### Integrating Packages as a Custom Package Set

Using this method may results in a faster build times compared to using overlays, but accessing packages will be different.

To use packages from a custom package set, follow these steps:

1. **Pass packages to `specialArgs`**:

    Pass the packages to your host's `specialArgs`:

    ```nix
    nixosConfigurations = {
      nixos = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgsCustom = inputs'.nixpkgs-custom.packages;
        };
      };
    };
    ```

1. **Use Your Packages**:

    Access the packages in this project like this:

    ```nix
    { pkgs, pkgsCustom, ... }:
    {
      environment.systemPackages = [
        pkgs.hello
        pkgsCustom.custom-pkg
      ];
    }
    ```

## Todo

- [x] Set up CI/CD to test and build packages
- [ ] Add a binary cache to speed up builds
