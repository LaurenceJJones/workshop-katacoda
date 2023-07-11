#!/bin/bash

# setup elk stack
git clone https://github.com/deviantony/docker-elk
cd docker-elk
docker compose up setup
docker compose up -d
