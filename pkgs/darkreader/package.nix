{
  lib,
  callPackage,
  buildFirefoxXpiAddon ? callPackage ../../lib/buildFirefoxXpiAddon.nix { },
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
let
  xpifile = buildNpmPackage (finalAttrs: {
    pname = "darkreader";
    version = "4.9.127";

    src = fetchFromGitHub {
      owner = "darkreader";
      repo = "darkreader";
      rev = "v${finalAttrs.version}";
      hash = "sha256-UkVo6GSyGV3U2nn5+IaPdYXqrYh0VgiQx3SApDoI574=";
    };

    postPatch = ''
      ln -sf ${./package-lock.json} package-lock.json
    '';

    npmDepsHash = "sha256-t3q6gcEphRkEjBggtAjsyDvQnsKAfOSjO9xDdFTSiCE=";
    npmBuildScript = "build:firefox";

    installPhase = ''
      runHook preInstall

      cp build/release/darkreader-firefox.xpi $out

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script { };
  });
in
buildFirefoxXpiAddon rec {
  inherit (xpifile) pname version;
  src = xpifile;

  addonId = "addon@darkreader.org";

  meta = {
    description = "Dark Reader Chrome and Firefox extension";
    homepage = "https://github.com/darkreader/darkreader";
    changelog = "https://github.com/darkreader/darkreader/blob/${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ dtomvan ];
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mozPermissions = [
      "alarms"
      "contextMenus"
      "storage"
      "tabs"
      "theme"
      "<all_urls>"
    ];
  };
}
