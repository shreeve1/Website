#!/usr/bin/env bash

# Script to start the TestyTech Designs website HTTP server
# This wrapper ensures we're in the correct directory

cd "/Users/james/Documents/AI/website"
exec /usr/bin/python3 -m http.server 8080 --bind 0.0.0.0
