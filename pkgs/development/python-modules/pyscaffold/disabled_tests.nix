{ 
  ignored_tests = [
    # `-m virtualenv` fails; importing virtualenv does not solve the issue
    "tests/test_install.py"
    "tests/system/test_dependency_managers.py" 

    # need configured git user account
    "tests/extensions/test_cookiecutter.py"
    "tests/extensions/test_django.py"
    "tests/extensions/test_no_skeleton.py"
    "tests/extensions/test_pre_commit.py"
    "tests/extensions/test_travis.py"
    "tests/system/test_common.py"
    
    # both
    "tests/extensions/test_tox.py"
  ];

  deselected_tests = [
    # `-m virtualenv` fails; importing virtualenv does not solve the issue
    "tests/test_update.py::test_update_version_3_0_to_3_1"
    "tests/test_update.py::test_update_version_3_0_to_3_1_pretend"
    "tests/system/test_common.py::test_ensure_inside_test_venv"
    "tests/conftest.py::test_pipenv_works_with_pyscaffold"
    
    # need full git repo
    "tests/test_integration.py::test_pyscaffold_keyword"
    
    # need configured git user account
    "tests/test_api.py::test_get_default_opts"
    "tests/test_api.py::test_api"
    "tests/test_api.py::test_pretend"
    "tests/test_api.py::test_pretend_when_updating_does_not_make_changes"
    "tests/test_info.py::test_project_without_args"
    "tests/test_info.py::test_project_with_args"
    "tests/test_info.py::test_dirty_workspace"
    "tests/test_repo.py::test_version_of_subdir"
    "tests/test_structure.py::test_define_structure"
    "tests/extensions/test_namespace.py::test_create_project_with_namespace"
    "tests/extensions/test_namespace.py::test_create_project_with_empty_namespace"
    "tests/extensions/test_namespace.py::test_create_project_without_namespace"
    "tests/extensions/test_namespace.py::test_cli_with_namespace"
    "tests/extensions/test_namespace.py::test_cli_without_namespace"
    "tests/extensions/test_namespace.py::test_move_old_package_without_namespace"
    "tests/extensions/test_namespace.py::test_move_old_package"
    "tests/extensions/test_namespace.py::test_pretend_move_old_package"
    "tests/extensions/test_namespace.py::test_updating_existing_project"
  ];
}
