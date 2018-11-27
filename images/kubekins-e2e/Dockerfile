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

ARG BASEIMAGE
FROM ${BASEIMAGE}

# Install goboring over the preexisting go.
ARG GO_VERSION
ENV GO_TARBALL "go${GO_VERSION}.linux-amd64.tar.gz"
ARG GO_URL_BASE
RUN rm -rf /usr/local/go && \
    wget -q "${GO_URL_BASE}/${GO_TARBALL}" && \
    tar xzf "${GO_TARBALL}" -C /usr/local && \
    rm -f "${GO_TARBALL}"

# The glibc source is needed by Bazel to include in ths src tarballs.
RUN apt-get update && apt-get install -y \
    glibc-source \
    && rm -rf /var/lib/apt/lists/*

# Update the image name.
ARG IMAGE
ENV IMAGE=${IMAGE}
