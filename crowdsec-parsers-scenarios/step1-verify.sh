#!/bin/bash

curl -s http://127.0.0.1:8080/health | grep -q status && exit 1 || exit 0