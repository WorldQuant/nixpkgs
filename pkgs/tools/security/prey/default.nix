{ stdenv, fetchurl, fetchgit, curl, scrot, imagemagick, xawtv, inetutils, makeWrapper, coreutils
, apiKey ? ""
, deviceKey ? "" }:

# TODO: this should assert keys are set, somehow if set through .override assertion fails
#assert apiKey != "";
#assert deviceKey != "";

let
  modulesSrc = fetchgit {
    url = "git://github.com/prey/prey-bash-client-modules.git";
    rev = "aba260ef110834cb2e92923a31f50c15970639ee";
    sha256 = "9cb1ad813d052a0a3e3bbdd329a8711ae3272e340379489511f7dd578d911e30";
  };
in stdenv.mkDerivation rec {
  pname = "prey-bash-client";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/prey/prey-bash-client/archive/v${version}.tar.gz";
    sha256 = "09cb15jh4jdwvix9nx048ajkw2r5jaflk68y3rkha541n8n0qwh0";
  };

  buildInputs = [ curl scrot imagemagick xawtv makeWrapper ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    substituteInPlace config --replace api_key=\'\' "api_key='${apiKey}'"
    substituteInPlace config --replace device_key=\'\' "device_key='${deviceKey}'"

    substituteInPlace prey.sh --replace /bin/bash $(type -Pp bash)
    mkdir -p $out/modules
    cp -R . $out
    cp -R ${modulesSrc}/* $out/modules/
    wrapProgram "$out/prey.sh" \
      --prefix PATH ":" "${stdenv.lib.makeBinPath [ xawtv imagemagick curl scrot inetutils coreutils ]}" \
      --set CURL_CA_BUNDLE "/etc/ssl/certs/ca-certificates.crt"
  '';

  meta = with stdenv.lib; {
    homepage = https://preyproject.com;
    description = "Proven tracking software that helps you find, lock and recover your devices when stolen or missing";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl3;
    platforms = with platforms; linux;
  };
}
