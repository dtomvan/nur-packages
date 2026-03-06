{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arborium-cli";
  version = "2.14.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-U6tKFyzW37BKx8Lc5Ag+kc+YySFZtTaQ3tf8/tqilX4=";
  };

  cargoHash = "sha256-xikCW9lbDp/ZtgOVbIh+LPwla1IGlHLzB0jB0YQ8eL4=";

  meta = {
    description = "Command-line syntax highlighter powered by arborium";
    homepage = "https://crates.io/crates/arborium-cli";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "arborium-cli";
  };
})
