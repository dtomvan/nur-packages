{
  clangStdenv,
  lib,
  replaceVars,
  fetchFromGitHub,
  rustc,
  fasm,
  nob_h,
  nix-update-script,
  makeWrapper,
}:
clangStdenv.mkDerivation {
  # TODO: when Tsoding starts building with nob, use buildNobPackage
  pname = "b";
  version = "0-unstable-2025-06-02";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "b";
    rev = "aa97e2ec480bb62cad7b005a047db3df9da02852";
    hash = "sha256-oZFzI84lhFxpWeY7cGULaGu7zfzdBBxhBC8RmoQg5Xs=";
  };

  patches = [
    (replaceVars ./use-nix-nob.patch {
      NOB_H = "${nob_h}/include/nob.h";
    })
  ];

  postPatch = "rm thirdparty/nob.h";

  nativeBuildInputs = [
    rustc
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp build/b $out/bin
    install -Dm444 examples/*.b -t $out/opt/b

    wrapProgram $out/bin/b \
      --prefix PATH : "${lib.makeBinPath [ fasm ]}"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Compiler for the B Programming Language implemented in Crust";
    homepage = "https://github.com/tsoding/b";
    license = lib.licenses.mit;
    mainProgram = "b";
  };
}
