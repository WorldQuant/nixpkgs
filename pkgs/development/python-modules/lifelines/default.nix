{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, autograd
, autograd-gamma
, dill
, matplotlib
, numpy
, pandas
, psutil
, pytest
, scikitlearn
, scipy
, flaky
}:

buildPythonPackage rec {
  pname = "lifelines";
  version = "0.23.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d7f63c8e05cc69d2bfbc1ffb4985e486941f6bece6cc951bb3c3fd9c681d6660";
  };

  propagatedBuildInputs = [
    autograd
    autograd-gamma
    matplotlib
    numpy
    pandas
    scipy
  ];

  checkInputs = [ dill flaky psutil pytest scikitlearn ];

  # test are nondeterministic, have known convergence problems
  # https://github.com/CamDavidsonPilon/lifelines/issues/917
  checkPhase = ''
    pytest lifelines \
    --ignore=lifelines/tests/test_estimation.py \
    --deselect=lifelines/tests/utils/test_utils.py::test_rmst_approximate_solution \
  '';

  meta = with lib; {
    description = "Survival analysis in Python";
    homepage = "https://github.com/CamDavidsonPilon/lifelines";
    license = licenses.mit;
    maintainers = [ maintainers.almac ];
  };
}

