#!/bin/bash

echo "${DEPLOY_KEY}" > key.key
echo "${DEPLOY_TOKEN}" | akash keys import ${AKASH_FROM} key.key
rm key.key
echo "${DEPLOY_CERT}" > ${AKASH_HOME}/$(akash keys show ${AKASH_FROM} --output=json | jq -r ".address").pem
akash query deployment list --owner ${AKASH_FROM} --state active
echo "./e2e $1 --skip-teardown=$2 --chain-id=$3 --keyring-backend=$4 --home=$5 --node=$6 --gas=$7 --from=$8"
