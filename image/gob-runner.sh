#!/usr/bin/env bash
# Copyright 2016 The Kubernetes Authors.
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
set -x

# Authenticate gcloud
if [[ -n "${GOOGLE_APPLICATION_CREDENTIALS:-}" ]]; then
  gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"
fi

gcloud config list

# Authenticate gerrit
git clone https://gerrit.googlesource.com/gcompute-tools
./gcompute-tools/git-cookie-authdaemon

curl -b ~/.git-credential-cache/cookie https://gke-internal.googlesource.com/?format=TEXT || true

# Clone internal kubernetes repo
git clone https://gke-internal.googlesource.com/kubernetes

cd kubernetes
git config --global user.email "foo@gmail.com"
git config --global user.name "prow"

# Clone a specific change from ref 
git pull https://gke-internal.googlesource.com/kubernetes refs/changes/81/1481/1
