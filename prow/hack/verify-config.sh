#!/usr/bin/env bash

TESTINFRA_ROOT=$(git rev-parse --show-toplevel)
PROW_GOB_CONFIG="${TESTINFRA_ROOT}/prow/gob/config.yaml"
PROW_INTERNAL_CONFIG="${TESTINFRA_ROOT}/prow/internal/config.yaml"

cd /workspace/test-infra

bazel test config/tests/jobs:go_default_test --test_arg="-config=${PROW_GOB_CONFIG}" --test_arg="-job-config=" --test_arg="-config-json="
bazel test config/tests/jobs:go_default_test --test_arg="-config=${PROW_INTERNAL_CONFIG}" --test_arg="-job-config=" --test_arg="-config-json="
