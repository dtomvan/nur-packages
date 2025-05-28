with builtins;
let
  isDerivation = p: isAttrs p && p ? type && p.type == "derivation";
  shouldRecurseForDerivations = p: isAttrs p && p.recurseForDerivations or false;
  flattenPkgs =
    s:
    let
      f =
        p:
        if shouldRecurseForDerivations p then
          flattenPkgs p
        else if isDerivation p then
          [ p ]
        else
          [ ];
    in
    concatMap f (attrValues s);
in
flattenPkgs
