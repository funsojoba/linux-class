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
