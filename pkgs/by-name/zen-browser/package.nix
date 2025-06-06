{
  lib,
  stdenv,
  fetchzip,
  makeDesktopItem,

  autoPatchelfHook,
  copyDesktopItems,
  wrapGAppsHook3,

  alsa-lib,
  dbus-glib,
  gtk3,
  xorg,

  libglvnd,
  libva,
  pciutils,
  pipewire,
}:
let
  desktopItem = makeDesktopItem {
    name = "zen-browser";
    desktopName = "Zen Browser";
    genericName = "Web Browser";
    categories = [
      "Network"
      "WebBrowser"
    ];
    keywords = [
      "internet"
      "www"
      "browser"
      "web"
      "explorer"
    ];
    exec = "zen %u";
    icon = "zen";
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    startupNotify = true;
    startupWMClass = "zen-alpha";
    terminal = false;
    actions = {
      new-window = {
        name = "New Window";
        exec = "zen --new-window %u";
      };
      new-private-window = {
        name = "New Private Window";
        exec = "zen --private-window %u";
      };
      profile-manager-window = {
        name = "Profile Manager";
        exec = "zen --ProfileManager %u";
      };
    };
  };
in
stdenv.mkDerivation rec {
  pname = "zen-browser-bin";
  version = "1.12.3b";

  src = fetchzip {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.xz";
    hash = "sha256-D6D+GIms/R2acQcirtJ6xkOmhSrUyaKp2aITVRxPkE8=";
  };

  desktopItems = [
    desktopItem
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    alsa-lib
    dbus-glib
    xorg.libXtst
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r $src $out/lib/zen/

    mkdir -p $out/bin
    ln -s $out/lib/zen/zen $out/bin/zen

    for n in {16,32,48,64,128}; do
        size=$n"x"$n
        mkdir -p $out/share/icons/hicolor/$size/apps
        file="default"$n".png"
        cp $out/lib/zen/browser/chrome/icons/default/$file $out/share/icons/hicolor/$size/apps/zen.png
    done

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libglvnd
          libva
          pciutils
          pipewire
        ]
      }"
    )
    gappsWrapperArgs+=(--set MOZ_LEGACY_PROFILES 1)
    wrapGApp $out/lib/zen/zen
  '';

  meta = {
    description = "Experience tranquillity while browsing the web without people tracking you!";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = lib.platforms.linux;
    mainProgram = "zen";
  };
}
