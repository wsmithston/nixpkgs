{ stdenv, lib, go, buildGoPackage, glide, fetchgit, git, cacert }:

buildGoPackage rec {
  name = "dcrd-${version}";
  version = "1.0.7";
  rev = "refs/tags/v${version}";
  goPackagePath = "github.com/decred/dcrd";

  buildInputs = [ go git glide cacert ];

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  src = fetchgit {
    inherit rev;
    url = "https://${goPackagePath}";
    sha256 = "03720yf9ayilzj5w8xjyh3cxh8r0fzyhk4zsmvqkc19cp9wbrzh7";
  };

  preBuild = ''
    export CWD=$(pwd)
    cd go/src/github.com/decred/dcrd
    export GLIDE_HOME=$(pwd)
    glide install
    glide cc
    go install $(glide nv)
    cd $CWD
  '';

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
  };
}
