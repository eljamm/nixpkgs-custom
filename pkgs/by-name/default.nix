{
  lib,
  callPackage,
  ...
}:
lib.pipe ./. [
  (lib.fileset.fileFilter (file: file.name == "package.nix"))
  (lib.fileset.toList)
  (map (file: rec {
    name = value.pname;
    value = callPackage file { };
  }))
  (lib.listToAttrs)
]
