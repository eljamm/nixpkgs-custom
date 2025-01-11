{
  lib,
  fetchFromGitHub,
  python3Packages,
  gst_all_1,
  qt5,
}:
let
  pyqtgraph5 = python3Packages.pyqtgraph.override {
    qt6 = qt5;
    pyqt6 = python3Packages.pyqt5_with_qtmultimedia;
  };
in
python3Packages.buildPythonApplication rec {
  pname = "vocabsieve";
  version = "0.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FreeLanguageTools";
    repo = "vocabsieve";
    rev = "v${version}";
    hash = "sha256-LTu/3I4blP72CaZo6o3fTDoufK9QNtSjE5umfvEpwAE=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtmultimedia
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    beautifulsoup4
    bidict
    charset-normalizer
    ebooklib
    flask
    gevent
    loguru
    lxml
    markdown
    markdownify
    mobi
    packaging
    pymorphy3
    pymorphy3-dicts-ru
    pymorphy3-dicts-uk
    pynput
    pyqt5_with_qtmultimedia
    pyqtdarktheme
    pyqtgraph5
    pystardict
    pysubs2
    python-lzo
    readmdict
    requests
    sentence-splitter
    simplemma
    slpp
    soupsieve
    typing-extensions
    waitress
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "pyqtdarktheme-fork" "pyqtdarktheme"
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    description = "Simple sentence mining tool for language learning";
    homepage = "https://github.com/FreeLanguageTools/vocabsieve";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "vocabsieve";
  };
}
