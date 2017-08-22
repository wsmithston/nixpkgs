{ stdenv, lib, go, buildGoPackage, glide, fetchgit, git, cacert }:

buildGoPackage rec {
  name = "dcrwallet-${version}";
  version = "1.0.7";
  rev = "refs/tags/v${version}";
  goPackagePath = "github.com/decred/dcrwallet";

  buildInputs = [ go git glide cacert ];

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}";
    sha256 = "1r3xqk9s0303jrcxmidjxypz8yar6mq6637l8crlw4wwbw1x8yg5";
  };

  preBuild = ''
    export CWD=$(pwd)
    cd go/src/github.com/decred/dcrwallet
    export GLIDE_HOME=$(pwd)
    glide install
    glide cc
  '';

  buildPhase = ''
    runHook preBuild
    go build
  '';

  installPhase = ''
    mkdir -pv $bin/bin
    cp -v dcrwallet $bin/bin
  '';


  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
  };
}
