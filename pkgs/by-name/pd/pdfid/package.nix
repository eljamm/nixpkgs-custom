{
  lib,
  fetchzip,
  python3,
  stdenvNoCC,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pdfid";
  version = "0.2.10";

  src =
    let
      underscoreVersion = lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version;
    in
    fetchzip {
      url = "https://didierstevens.com/files/software/pdfid_v${underscoreVersion}.zip";
      hash = "sha256-GxQOwIwCVaKEruFO+kxXciOiFcXtBO0vvCwb6683lGU=";
      stripRoot = false;
    };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/pdfid}
    cp -a * $out/share/pdfid/

    makeWrapper ${python3.interpreter} $out/bin/pdfid \
      --add-flags "$out/share/pdfid/pdfid.py"

    runHook postInstall
  '';

  postFixup = ''
    for f in $out/share/pdfid/*.py; do
      substituteInPlace $f \
        --replace-fail '/usr/bin/env python' ${python3.interpreter}
    done
  '';

  meta = {
    description = "Scan a file to look for certain PDF keywords";
    homepage = "https://blog.didierstevens.com/programs/pdf-tools/";
    license = lib.licenses.free;
    mainProgram = "pdfid";
    platforms = lib.platforms.unix;
  };
})
