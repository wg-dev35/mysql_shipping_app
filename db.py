# -    -    -       -       -       -       -       -       -       -       -    
# db configuration & connection - done as a blueprint for further expansion
# -    -    -       -       -       -       -       -       -       -       -    
import os
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.sql import text

db = SQLAlchemy()
  
# -    -    -       -       -       -       -       -       -       -       -    
# database model
# -    -    -       -       -       -       -       -       -       -       -    
class Role(db.Model):
    __tablename__ = 'roles'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), unique=True)
    users = db.relationship('User', backref='role')

    def __repr__(self):
        return '<Role %r>' % self.name

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), unique=True, index=True)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.id'))