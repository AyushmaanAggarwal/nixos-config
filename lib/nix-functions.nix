{
  inputs,
  outputs,
  lib,
  ...
}:
{
  listToAttrsAttrs = (list: (attrs: lib.genAttrs list (element: attrs)));
}
