#!/bin/bash

FILE_DIR = $1

if [[ $FILE_DIR -d]]; then
    echo "File path already exists"



touch config.py manage.py requirements.txt

cat <<EOL > requirements.txt
Flask
Flask-RESTful
Flask-Cors
Flask-Migrate
Flask-JWT-Extended
Flask-SQLAlchemy
Flask-Marshmallow
EOL

touch .gitignore

cat <<EOL > .gitignore
# Created by https://www.toptal.com/developers/gitignore/api/flask
# Edit at https://www.toptal.com/developers/gitignore?templates=flask

### Flask ###
instance/*
!instance/.gitignore
.webassets-cache
.env

### Flask.Python Stack ###
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class
.DS_Store

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
#   For a library or package, you might want to ignore these files since the code is
#   intended to run in multiple environments; otherwise, check them in:
# .python-version

# pipenv
#   According to pypa/pipenv#598, it is recommended to include Pipfile.lock in version control.
#   However, in case of collaboration, if having platform-specific dependencies or dependencies
#   having no cross-platform support, pipenv may install dependencies that don't work, or not
#   install all needed dependencies.
#Pipfile.lock

# poetry
#   Similar to Pipfile.lock, it is generally recommended to include poetry.lock in version control.
#   This is especially recommended for binary packages to ensure reproducibility, and is more
#   commonly ignored for libraries.
#   https://python-poetry.org/docs/basic-usage/#commit-your-poetrylock-file-to-version-control
#poetry.lock

# pdm
#   Similar to Pipfile.lock, it is generally recommended to include pdm.lock in version control.
#pdm.lock
#   pdm stores project-wide configurations in .pdm.toml, but it is recommended to not include it
#   in version control.
#   https://pdm.fming.dev/#use-with-ide
.pdm.toml

# PEP 582; used by e.g. github.com/David-OConnor/pyflow and github.com/pdm-project/pdm
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/

# PyCharm
#  JetBrains specific template is maintained in a separate JetBrains.gitignore that can
#  be found at https://github.com/github/gitignore/blob/main/Global/JetBrains.gitignore
#  and can be added to the global gitignore or merged into this file.  For a more nuclear
#  option (not recommended) you can uncomment the following to ignore the entire idea folder.
#.idea/

# End of https://www.toptal.com/developers/gitignore/api/flask
EOL

cat <<EOL > config.py
import os

SECRET_KEY = 'your_secret_key'
SQLALCHEMY_DATABASE_URI = 'your_database_uri'
SQLALCHEMY_TRACK_MODIFICATIONS = False
JWT_SECRET_KEY = 'your_jwt_secret_key'
EOL


mkdir app && cd app
touch __init__.py models.py

cat <<EOL > __init__.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager
from flask_cors import CORS

from app.routes.auth import SignupResource

app = Flask(__name__)
app.config.from_object('config')
db = SQLAlchemy(app)
jwt = JWTManager(app)
CORS(app)


api.add_resource(SignupResource, '/signup')

# Import and register your API routes here

if __name__ == '__main__':
    app.run()
EOL

cat <<EOL > models.py
from app import db

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)

    def __init__(self, username, password):
        self.username = username
        self.password = password
EOL



mkdir test routes schemas

cd schemas
touch user_schema.py

cat <<EOL > user_schema.py
from marshmallow import Schema, fields

class UserSchema(Schema):
    id = fields.Int(dump_only=True)
    username = fields.Str(required=True)
    password = fields.Str(required=True)
EOL


cd ../routes 
touch __init__.py auth.py

cat <<EOL > auth.py
from flask import request
from flask_restful import Resource
from flask_jwt_extended import create_access_token
from app import db
from app.models import User
from app.schemas.user_schema import UserSchema

user_schema = UserSchema()

class SignupResource(Resource):
    def post(self):
        try:
            data = user_schema.load(request.get_json())

            username = data['username']
            password = data['password']

            if User.query.filter_by(username=username).first():
                return {'message': 'Username already exists'}, 400

            user = User(username=username, password=password)
            db.session.add(user)
            db.session.commit()

            access_token = create_access_token(identity=user.id)
            return {'message': 'User registered successfully', 'access_token': access_token}, 201
        except Exception as e:
            return {'message': 'Error occurred while registering user', 'error': str(e)}, 500
EOL


echo "A flask app has been spun up for you, you can edit the folders and files as you please and run the following code for your db migarion"
echo "python3 -m venv venv"
echo "source venv/bin/activate  #for Mac users" 
echo "pip install -r requirements.txt"
echo "flask db init"
echo "flask db migrate"
echo "flask db upgrade"