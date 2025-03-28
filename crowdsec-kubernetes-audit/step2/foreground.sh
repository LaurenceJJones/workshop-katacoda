#!/bin/bash

# waiting for the cluster to be ready
echo "Waiting for crowdsec deployment to be ready... (this may take a few minutes)"
while [ ! -f /root/done ]; do sleep 2; done
echo "crowdsec deployment is ready"

rm /root/done