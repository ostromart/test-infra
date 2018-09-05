#!/usr/bin/env bash

set -e
set -o pipefail

trap "exit" INT

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

while [ "${1}" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case "${PARAM}" in
        --dry-run)
			            DRY="${VALUE}"
			            ;;
        --region)
			            REPLACE=--gcp-region
			            LOCATION="${VALUE}"
                  ;;
        --zone)
			            REPLACE=--gcp-zone
			            LOCATION="${VALUE}"
			            ;;
        *)
                  echo "ERROR: unknown parameter \"${PARAM}\""
                  exit 1
                  ;;
    esac
    shift
done

if [ -z "${LOCATION}" ]
then
	echo "Please provide either --zone or --region"
	exit 1
fi

cd "${CWD}"/../gob && make get-cluster-credentials
docker run \
  --entrypoint=/bin/sh \
  -v "${CWD}"/../gob:/gob gcr.io/k8s-testimages/kubekins-e2e:v20180402-7b54c4ba6-master \
  -c "git clone https://github.com/kubernetes/test-infra && cd test-infra &&  bazel run //prow/cmd/mkpj -- --job=ci-kubernetes-e2e-gob-gke --config-path=/gob/config.yaml" |
sed "s/--gcp-zone=.*/${REPLACE}=${LOCATION}/ ; s/--gke-environment=staging/--gke-environment=prod/" |
(([ "${DRY}" = false ] && kubectl create -f -) || (cat && echo -e "\nRun with --dry-run=false to execute the job."))