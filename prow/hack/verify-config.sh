#!/usr/bin/env bash

TESTINFRA_ROOT=$(git rev-parse --show-toplevel)
GUBERNATOR_URL="https://gubernator-internal.googleplex.com"

cd $GOPATH/k8s.io/test-infra

# exit code
EXIT=0

# GoB Prow
PROW_GOB_CONFIG="${TESTINFRA_ROOT}/prow/gob/config.yaml"
PROW_GOB_BUCKET="gob-prow"

bazel test config/tests/jobs:go_default_test --test_arg="-config=${PROW_GOB_CONFIG}" --test_arg="-job-config=" --test_arg="-gubernator-path=${GUBERNATOR_URL}" --test_arg="-bucket=${PROW_GOB_BUCKET}" --test_arg="-k8s-prow=false" || EXIT=$?

# Internal prow
PROW_INTERNAL_CONFIG="${TESTINFRA_ROOT}/prow/internal/config.yaml"
PROW_INTERNAL_BUCKET="gke-prow"

bazel test config/tests/jobs:go_default_test --test_arg="-config=${PROW_INTERNAL_CONFIG}" --test_arg="-job-config=" --test_arg="-gubernator-path=${GUBERNATOR_URL}" --test_arg="-bucket=${PROW_INTERNAL_BUCKET}" --test_arg="-k8s-prow=false" || EXIT=$?

# When both bazel command fail, we are choosing to return the second one.
exit "${EXIT}"
