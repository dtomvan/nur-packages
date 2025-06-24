{
  clangStdenv,
  lib,
  rustc,

  fetchFromGitHub,
  nix-update-script,
  makeWrapper,

  fasm,
  uxn,
  binutils,
}:
let
  runtimeDeps = [
    fasm
    uxn
  ] ++ lib.optionals (clangStdenv.hostPlatform.system == "aarch64-linux") [ binutils ];
in
clangStdenv.mkDerivation {
  # TODO: when Tsoding starts building with nob, use buildNobPackage
  pname = "b";
  version = "0-unstable-2025-06-24";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "b";
    rev = "3b1c6402901c41aca4e1c6a112ed2b12b974947e";
    hash = "sha256-QDD3VqCDlBNIh6V5/s74yaoKis9JB2Q+Oi7IxjZkhc4=";
  };

  nativeBuildInputs = [
    rustc
    makeWrapper
  ];

  doCheck = true;
  nativeCheckInputs = runtimeDeps;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/b/
    cp build/b $out/bin
    cp -r examples $out/opt/b

    wrapProgram $out/bin/b \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"

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
