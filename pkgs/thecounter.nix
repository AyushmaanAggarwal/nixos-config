{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "theCounter";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AyushmaanAggarwal";
    repo = "theCounter";
    tag = version;
    hash = "sha256-";
  };

  # calibre-web doesn't follow setuptools directory structure.
  postPatch = ''
    mkdir -p src/calibreweb
    mv cps.py src/calibreweb/__init__.py
    mv cps src/calibreweb

    substituteInPlace pyproject.toml \
      --replace-fail 'cps = "calibreweb:main"' 'calibre-web = "calibreweb:main"'
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    flask
    flask-login
    flask-admin
    flask-sqlalchemy
    flask-wtf
    # flask-migrate
    # flask-mail
    # flask-security
    # flask-expects-json
    
    apscheduler
    requests
    gunicorn
    sqlalchemy
  ];

  optional-dependencies = {
    gmail = with python3Packages; [
      google-api-python-client
      google-auth-oauthlib
      google-auth-httplib2
    ];
 };

  pythonRelaxDeps = [
    "apscheduler"
    "flask"
  ];

  nativeCheckInputs = lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "calibreweb" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Web app for theCounter Website";
    homepage = "https://github.com/AyushmaanAggarwal/theCounter";
    # license = lib.licenses.gpl3Plus;
    mainProgram = "calibre-web"; # Change
    platforms = lib.platforms.all;
  };
}
