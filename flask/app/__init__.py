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
