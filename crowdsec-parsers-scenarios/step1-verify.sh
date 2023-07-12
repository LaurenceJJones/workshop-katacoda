#!/bin/bash

curl -s http://127.0.0.1:8080/health | grep -q status || echo "CrowdSec is not running, please wait a few seconds and try again." && exit 1