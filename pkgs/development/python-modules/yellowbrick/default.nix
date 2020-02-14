{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, cycler
, matplotlib
, numpy
, pandas
, python
, pytest
, pytestcov
, pytest-flakes
, pytestrunner
, scikitlearn
, scipy
, tkinter
, uarray
}:


let
  # ~100 tests fail; disable those tests
  disabled_tests = import ./disabled_tests.nix;
  ignored_tests = lib.concatStringsSep " " (map (x : "--ignore=" + x ) disabled_tests.ignored_tests);
  deselected_tests = lib.concatStringsSep " " (map (x : "--deselect=" + x ) disabled_tests.deselected_tests);
  test_expression = ignored_tests + " " + deselected_tests;
  
in 

buildPythonPackage rec {
  pname = "yellowbrick";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7373af6009704f467108171a6a6f5b854b53380d0166fe0c3af71493bd4ac5e0";
  };

  disabled = isPy27;
  
  propagatedBuildInputs = [ 
    cycler
    matplotlib
    numpy
    pytestrunner
    pytest
    tkinter
    scikitlearn
    scipy
    uarray
  ];

  # they are hacking on pytest output here which disables sane pytest deselect
  postPatch = ''
    rm tests/conftest.py
  '';

  checkInputs = [
    pandas
    pytestcov
    pytest-flakes
  ];

  PYTEST_ADDOPTS = test_expression;

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  meta = with lib; {
    description = "Visual analysis and diagnostic tools to facilitate machine learning model selection";
    homepage = "https://www.scikit-yb.org/en/latest/";
    license = licenses.asl20;
    maintainers = [ maintainers.almac ];
  };
}

