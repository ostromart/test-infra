#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

TESTINFRA_ROOT=$(git rev-parse --show-toplevel)
PROW_CONFIG="${TESTINFRA_ROOT}/prow/gob/config.yaml"

cd /workspace/test-infra

bazel test prow/config/jobtests:go_default_test --test_arg=-config="${PROW_CONFIG}"
