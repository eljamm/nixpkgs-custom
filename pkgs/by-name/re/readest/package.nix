{
  readest,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_11,
  rustPlatform,
}:
readest.overrideAttrs (
  finalAttrs: oldAttrs: {
    version = "0.12.16";

    src = fetchFromGitHub {
      owner = "readest";
      repo = "readest";
      tag = "v${finalAttrs.version}";
      hash = "sha256-XNN66MB13yqHCvnBUgPmdghRnXA7Kz13E0j82EqxocU=";
      fetchSubmodules = true;
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-LPm50VC7KU1wysxSUxwFZ7pNZutULct05NB5WgjmTws=";
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
      hash = "sha256-8wiIf4MFgOUPvljgLN7kbx3H/r57jjiqsxN5P5rZCAA=";
    };
  }
)
