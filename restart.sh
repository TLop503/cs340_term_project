#!/bin/bash

pkill gunicorn
gunicorn -b 0.0.0.0:1739 -D app:app