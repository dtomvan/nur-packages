{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dodeca";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "bearcove";
    repo = "dodeca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c6JQZLNOt4rmkNVlElALzl4Ph9+bzHpzesxUJDzM/QI=";
  };

  cargoHash = "sha256-DAD/BBHBTUx3hVxssB0QaDIu9kQT+Fz1Z3lqdqRIcf0=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  meta = {
    description = "A query-system-based static site generator";
    homepage = "https://github.com/bearcove/dodeca";
    changelog = "https://github.com/bearcove/dodeca/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "dodeca";
  };
})
