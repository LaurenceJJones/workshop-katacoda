#!/bin/bash

# waiting for the cluster to be ready
echo "Waiting apiserver to restart with new configuration..."
while [ ! -f /root/done ]; do sleep 2; done
echo "apiserver has restarted with new configuration"

rm /root/done