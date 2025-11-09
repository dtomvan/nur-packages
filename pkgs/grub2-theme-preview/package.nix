{
  lib,
  python3,
  fetchFromGitHub,
  makeWrapper,
  OVMF,
  grub2_efi,
  libisoburn,
  mtools,
  qemu,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "grub2-theme-preview";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "grub2-theme-preview";
    rev = version;
    hash = "sha256-JJOFgID/53dscHdXvt3aMfswsla401F0rAjPOYEzx3o=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    attrs
    coverage
    exceptiongroup
    importlib-metadata
    iniconfig
    packaging
    parameterized
    pluggy
    pyparsing
    pytest
    tomli
    typing-extensions
    zipp

    makeWrapper
  ];

  pythonImportsCheck = [
    "grub2_theme_preview"
  ];

  postInstall = ''
    wrapProgram $out/bin/grub2-theme-preview \
      --prefix PATH : "${
        lib.makeBinPath [
          grub2_efi
          libisoburn
          mtools
          qemu
        ]
      }" \
      --set-default G2TP_OVMF_IMAGE "${OVMF.fd}/FV/OVMF_CODE.fd" \
      --set-default G2TP_GRUB_LIB "${grub2_efi}/lib/grub"
  '';

  meta = {
    description = "Preview a full GRUB 2.x theme using QEMU";
    homepage = "https://github.com/hartwork/grub2-theme-preview";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dtomvan ];
    mainProgram = "grub2-theme-preview";
    platforms = [ "x86_64-linux" ]; # AFAICT
  };
}
