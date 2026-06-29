{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "mo";
  version = "1.6.3";

  src = pkgs.fetchurl {
    url = "https://github.com/k1LoW/mo/releases/download/v${version}/mo_v${version}_linux_amd64.tar.gz";
    hash = "sha256-sobqdBSeLI9zzbjjioK9YiOnhpYoAb3pq2p1CcJcjfA=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 mo $out/bin/mo
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/k1LoW/mo";
    description = "Markdown viewer that opens .md files in a browser";
    license = pkgs.lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "mo";
  };
}
