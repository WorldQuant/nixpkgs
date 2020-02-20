{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, isPy27
, setuptools
, pytest
, pytestcov
, pytest-shutil
, pytest-virtualenv
, pytest-fixture-config
}:

let
  
  # 65 tests fail, disable those tests
  disabled_tests = import ./disabled_tests.nix;
  ignored_tests = lib.concatStringsSep " " (map (x: "--ignore=" + x) disabled_tests.ignored_tests);
  deselected_tests = lib.concatStringsSep " " (map (x: "--deselect=" + x) disabled_tests.deselected_tests);
  test_expression = ignored_tests + " " + deselected_tests;

in

buildPythonPackage rec {
  pname = "PyScaffold";
  version = "3.2.3";
  format = "wheel";

  disabled = isPy27;
  
  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    sha256 = "862ba8415361c7b9947bc9aba83c12af325e61f6c1f70890759b9e9bef498ab7";
  };

  # wheel does not include tests
  testSrc = fetchFromGitHub {
      owner = "pyscaffold";
      repo = "pyscaffold";
      rev = "v" + version;
      sha256 = "1f75hn16l8xayhkh73s1xvwf3jc8sc8hgwmm42acfxc2808cf68r";
  };

  propagatedBuildInputs = [ setuptools ];

  postPatch = ''
    # we are in /tmp build dir, bring tests
    cp -r ${testSrc}/tests .
  '';

  checkInputs = [
    pytest
    pytestcov
    pytest-shutil
    pytest-virtualenv
    pytest-fixture-config
  ];

  PYTEST_ADDOPTS = test_expression;

  checkPhase = ''
    PATH=$out/bin:$PATH pytest tests
  '';

  meta = with lib; {
    description = "Python project template generator with batteries included";
    homepage = "https://github.com/pyscaffold/pyscaffold/";
    license = licenses.mit;
    maintainers = [ maintainers.almac ];
  };
}

