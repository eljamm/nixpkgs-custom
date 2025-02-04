{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
with python3Packages;
buildPythonPackage rec {
  pname = "cleanit";
  version = "0.4.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ratoaq2";
    repo = "cleanit";
    rev = version;
    hash = "sha256-z1QAWWm+yg/pRCQfPqGbL0EFFT9UwqIkwhmjUuRHyuk=";
  };

  nativeBuildInputs = [ poetry-core ];

  dependencies = [
    appdirs
    babelfish
    chardet
    click
    jsonschema
    pysrt
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/ratoaq2/cleanit/releases/tag/${version}";
    description = "Command line tool that helps you to keep your subtitles clean";
    homepage = "https://github.com/ratoaq2/cleanit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "cleanit";
  };
}
