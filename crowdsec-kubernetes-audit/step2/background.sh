#!/bin/bash

kubectl wait --for=condition=Ready $(kubectl -n crowdsec get pods -l type=agent -o jsonpath='{.items[0].metadata.name}')