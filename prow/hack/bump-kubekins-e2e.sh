#!/usr/bin/env bash
# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

TESTINFRA_ROOT=$(git rev-parse --show-toplevel)
DATE="$(date +v%Y%m%d)"
TAG="${DATE}-$(git describe --tags --always --dirty)"

# We only want to update tags for the gke-test-infra kubekins-e2e
GKE_KUBEKINS_E2E="gcr.io/gke-test-infra/kubekins-e2e"

dirty="$(git status --porcelain)"
if [[ -n "${dirty}" ]]; then
  echo "Tree not clean:"
  echo "${dirty}"
  exit 1
fi

make -C "${TESTINFRA_ROOT}/images/kubekins-e2e" all-push

echo "Updating configs to use newly published tag ${TAG}"
# Search for tags starting with v to prevent replacing :latest-
find "${TESTINFRA_ROOT}/prow/gob/config/" -type f -name \*.yaml -exec \
  sed -i "s|${GKE_KUBEKINS_E2E}:v.*-\\(.*\\)$|${GKE_KUBEKINS_E2E}:${TAG}-\\1|" {} \;

git commit -am "Bump to ${GKE_KUBEKINS_E2E}:${TAG}-(master|experimental|releases)"
