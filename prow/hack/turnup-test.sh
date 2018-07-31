#!/usr/bin/env bash

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --region)
            REGION=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            exit 1
            ;;
    esac
    shift
done

cd ../gob && make get-cluster-credentials
docker run --entrypoint=/bin/sh -v $PWD/../gob:/gob gcr.io/k8s-testimages/kubekins-e2e:v20180402-7b54c4ba6-master -c "git clone https://github.com/kubernetes/test-infra && cd test-infra &&  bazel run //prow/cmd/mkpj -- --job=ci-kubernetes-e2e-gob-gke --config-path=/gob/config.yaml | sed 's/--gcp-zone=.*/--gcp-region=$REGION/'" | kubectl create -f -