{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-auth
, grpcio
, mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "2.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uVKe5wR/2NS/SiGC3mGRVCQN8X++YOrTmQeMGuFSr5o=";
  };

  propagatedBuildInputs = [
    google-auth
    google-api-core
  ];

  passthru.optional-dependencies = {
    grpc = [
      grpcio
    ];
  };

  checkInputs = [
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.grpc;

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud"
  ];

  meta = with lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = "https://github.com/googleapis/python-cloud-core";
    changelog = "https://github.com/googleapis/python-cloud-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
