

# import libraries
import os
from db import db
import json
import numpy as np
import pandas as pd
import plotly.express as px
import plotly
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from routes import main

# -    -    -       -       -       -       -       -       -       -       -    
from datetime import datetime
from dotenv import load_dotenv

# -    -    -       -       -       -       -       -       -       -       -    
from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
from wtforms.validators import DataRequired

# Flask libraries for the webapp
# -    -    -       -       -       -       -       -       -       -       -    
from flask import Flask, request, render_template, session, redirect, url_for

#app instance and config 
# -    -    -       -       -       -       -       -       -       -       -    
app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('SQLALCHEMY_DATABASE_URI')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = os.getenv('SQLALCHEMY_TRACK_MODIFICATIONS')
db.init_app(app)
# -    -    -       -       -       -       -       -       -       -       -    

# -    -    -       -       -       -       -       -       -       -       -    
# app routes
app.register_blueprint(main)



if __name__ == '__main__':
	app.run()