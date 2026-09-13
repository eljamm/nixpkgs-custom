{
  lib,
  ...
}:
{
  /*
    Compares 2 packages and returns `true` if the first is newer than the
    second or the same.

    Reference:
    *  0: same version
    *  1: p1 is newer
    * -1: p1 is older

    https://noogle.dev/f/lib/versions/compareVersions
  */
  isNewerOrSame = p1: p2: (lib.strings.compareVersions p1.version p2.version) != -1;

  # Pass condition with custom message and warn if it's true.
  warnIfCond = cond: msg: lib.warnIf cond msg cond;
}
