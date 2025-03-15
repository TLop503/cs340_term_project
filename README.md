# cs340_term_project
Term project for Intro to Databases; A library management system

## Setup
To run this app from scratch, you'll first need to install dependencies. We use the python packages for flask and mysql for interacting with the internet and the database. Next, you'll need to sign in to mysql, and run the DDL to create the neccessary tables. Lastly, a .env file in the root of the project with your mysql credentials (or, for a non-human account created beforehand) is required for the webserver to talk to the db. Once this is done, you can `python3 app.py` to start up the test server.

## Citations
Citation for the following function:
Date: 3/15/2025
Based on and adapted from `gkochera`
I used the given skeleton code from the assignment description to get the bare-bones
flask set up, and then heavily edited the src to include env vars instead of plaintext passwords, as well
as to execute all of the queries and endpoints we needed for this project.
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app
