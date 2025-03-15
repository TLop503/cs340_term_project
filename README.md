# cs340_term_project
Term project for Intro to Databases; A library management system

## Setup
To run this app from scratch, you'll first need to install dependencies. We use the python packages for flask and mysql for interacting with the internet and the database. Next, you'll need to sign in to mysql, and run the DDL to create the neccessary tables. Lastly, a .env file in the root of the project with your mysql credentials (or, for a non-human account created beforehand) is required for the webserver to talk to the db. Once this is done, you can `python3 app.py` to start up the test server.

## Citations
Citation for app.py:
Date: 3/15/2025
Based on and adapted from `gkochera`'s flask starter app.py-- the given example code from class.
We used the general route outline, but all of the endpoints are unique. Additionally, we use a unique endpoint for each operation, rather than forking on request.method to aid in readability.
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app
