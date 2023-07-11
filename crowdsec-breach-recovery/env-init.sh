#!/bin/bash

# setup elk stack
wget -qO- https://github.com/deviantony/docker-elk/archive/refs/tags/8.2302.1.tar.gz | tar xvz
cd docker-elk*
docker-compose up setup
docker-compose up -d
