#!/bin/bash

# waiting for the cluster to be ready
while [ ! -f /root/done ]; do sleep 2; done