#!/bin/bash

kubectl -n crowdsec wait --for=condition=Ready pod $(kubectl -n crowdsec get pods -l type=agent -o jsonpath='{.items[0].metadata.name}')
touch /root/done