{
  clangStdenv,
  lib,
  replaceVars,
  fetchFromGitHub,
  rustc,
  fasm,
  nob_h,
  nix-update-script,
}:
clangStdenv.mkDerivation {
  # TODO: when Tsoding starts building with nob, use buildNobPackage
  pname = "b";
  version = "0-unstable-2025-05-26";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "b";
    rev = "cbe341c184c378cc888cc313b0ef984ce31b821e";
    hash = "sha256-e1OGgVAyYLdZP4IIz3Y+Ir+mO5caclYciISP/ARorcU=";
  };

  patches = [
    (replaceVars ./use-nix-nob.patch {
      NOB_H = "${nob_h}/include/nob.h";
    })
  ];

  postPatch = "rm thirdparty/nob.h";

  nativeBuildInputs = [
    rustc
    fasm
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/b/examples
    cp build/b $out/bin
    # removed (temporarily?)
    # cp build/{hello.js,hello} index.html $out/opt/b/examples

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
