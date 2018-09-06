#!/bin/bash

set -x

gcloud auth activate-service-account \
  gob-prow@gob-prow.iam.gserviceaccount.com \
  --key-file=/usr/local/.secret/service-account-key-file --project=gob-prow

make -C /usr/local/config get-cluster-credentials

# Check the connection with Prow Cluster
kubectl get pod

mkpj \
--config-path /usr/local/config/config.yaml \
--job ${PROW_JOB} | \
kubectl label --local=true pubsub-project=${PUBSUB_PROJECT} pubsub-topic=${PUBSUB_TOPIC} pubsub-runID=${PUBSUB_RUNID} -o yaml -f - | \
tee prowjob.yaml

kubectl apply -f prowjob.yaml
