{ stdenv, fetchPypi, buildPythonPackage, execnet, pytest
, setuptools_scm, pytest-forked, filelock, psutil, six, isPy3k }:

buildPythonPackage rec {
  pname = "pytest-xdist";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3217b1f40290570bf27b1f82714fc4ed44c3260ba9b2f6cde0372378fc707ad3";
  };

  nativeBuildInputs = [ setuptools_scm pytest ];
  checkInputs = [ pytest filelock ];
  propagatedBuildInputs = [ execnet pytest-forked psutil six ];

  # Encountered a memory leak
  # https://github.com/pytest-dev/pytest-xdist/issues/462
  doCheck = !isPy3k;

  checkPhase = ''
    # Excluded tests access file system
    py.test testing -k "not test_distribution_rsyncdirs_example \
                    and not test_rsync_popen_with_path \
                    and not test_popen_rsync_subdir \
                    and not test_init_rsync_roots \
                    and not test_rsyncignore"
  '';

  meta = with stdenv.lib; {
    description = "py.test xdist plugin for distributed testing and loop-on-failing modes";
    homepage = "https://github.com/pytest-dev/pytest-xdist";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
