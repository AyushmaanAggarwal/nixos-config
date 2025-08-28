{
  inputs,
  outputs,
  lib,
  ...
}:
{
  listToAttrs = (list: (attrs: lib.genAttrs list (element: attrs)));
}
