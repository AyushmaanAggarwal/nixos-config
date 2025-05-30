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

  build-system = [python3Packages.setuptools];

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

  passthru = {
    updateScript = nix-update-script {};
  };

  meta = {
    description = "Web app for theCounter Website";
    homepage = "https://github.com/AyushmaanAggarwal/theCounter";
    license = lib.licenses.agpl3Only;
    mainProgram = "nix"; # Change
    platforms = lib.platforms.all;
  };
}
# ADD TO MODULE
# systemd.services.gunicorn = {
#   enable = true;
#   description = "gunicorn daemon";
#   # In NixOS, you refer to dependencies by name without the suffix.
#   requires = [ "gunicorn.socket" ];
#   after = [ "network.target" ];
#   serviceConfig = {
#     Type = "notify";
#     NotifyAccess = "main";
#     User = "counter";
#     Group = "counter";
#     DynamicUser = true;
#     RuntimeDirectory = "gunicorn";
#     WorkingDirectory = "/home/proxmox/theCounter";
#     ExecStart = "/usr/bin/gunicorn applicationname.wsgi";
#     ExecReload = "/bin/kill -s HUP $MAINPID";
#     KillMode = "mixed";
#     TimeoutStopSec = "5";
#     PrivateTmp = true;
#     ProtectSystem = "strict";
#   };
#   wantedBy = [ "multi-user.target" ];
# };
#
# # Define the gunicorn socket unit
# systemd.sockets.gunicorn = {
#   enable = true;
#   description = "gunicorn socket";
#   # Listen on a Unix socket
#   listenStream = "/run/gunicorn.sock";
#   socketConfig = {
#     SocketUser = "www-data";
#     SocketGroup = "www-data";
#     SocketMode = "0660";
#   };
#   wantedBy = [ "sockets.target" ];
# };

