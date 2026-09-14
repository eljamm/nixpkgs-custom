{
  readest,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_11,
  rustPlatform,
}:
readest.overrideAttrs (
  finalAttrs: oldAttrs: {
    version = "0.12.8";

    src = fetchFromGitHub {
      owner = "readest";
      repo = "readest";
      tag = "v${finalAttrs.version}";
      hash = "sha256-QPYqbmj3Gn7ghGyFfnaMx5g+ogi/Zs3eL8DmmwpwUNs=";
      fetchSubmodules = true;
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-E6z6mXT4fO5TueLiJ03xHTM0CN3u+zXiSfdioi8R85Q=";
      pnpmInstallFlags = [
        # Increase number of fetch attempts to work around timeout issues on slow
        # networks: "TimeoutError: The operation was aborted due to timeout".
        #
        # If this still happens on your network, consider changing some of the
        # fetch setting and opening a pull request:
        # https://pnpm.io/settings#request-settings
        "--fetch-retries=5"
      ];
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-+SDs/Da3ssM59ydJHCjr90gxYTHBYwik+mKS85ZqfCI=";
    };
  }
)
