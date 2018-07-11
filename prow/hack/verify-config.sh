#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

TESTINFRA_ROOT=$(git rev-parse --show-toplevel)
PROW_GOB_CONFIG="${TESTINFRA_ROOT}/prow/gob/config.yaml"
PROW_INTERNAL_CONFIG="${TESTINFRA_ROOT}/prow/internal/config.yaml"

cd /workspace/test-infra

bazel test config/tests/jobs:go_default_test --test_arg=-config="${PROW_GOB_CONFIG}"
bazel test config/tests/jobs:go_default_test --test_arg=-config="${PROW_INTERNAL_CONFIG}"
