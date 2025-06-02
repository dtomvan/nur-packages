{
  fetchFromGitHub,
  stdenv,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "uProd";
  version = "0-unstable-2025-04-28";

  src = fetchFromGitHub {
    owner = "ublockorigin";
    repo = "uAssets";
    rev = "d40038fc816d1403cde41ca234d2349fd0a1bc73";
    hash = "sha256-Dwt6th0QCHmWIHtXgl+5sLSXhGSLJUpeTB52w5jdPew=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { branch = "gh-pages"; };
}
