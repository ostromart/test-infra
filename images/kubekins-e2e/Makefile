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

BASE_IMG = gcr.io/k8s-testimages/kubekins-e2e
BASE_TAG ?= v20181122-a5bf59311

IMG = gcr.io/gke-test-infra/kubekins-e2e
TAG := $(shell date +v%Y%m%d)-$(shell git describe --tags --always --dirty)

ALL_K8S=master experimental 1.13 1.12 1.11 1.10 1.9

K8S ?= master
# TODO(jgrafton): update to 1.11.2b4 when available
GO_VERSION ?= 1.11b4
BAZEL = 0.18.0
GO_URL_BASE ?= https://storage.googleapis.com/go-boringcrypto

FULL_IMG=$(IMG):$(TAG)-$(K8S)

ifeq ($(K8S), experimental)
	# TODO(jgrafton): update to 1.11.2b4 when available
	GO_VERSION = 1.11b4
	BAZEL = 0.20.0
endif
ifeq ($(K8S), 1.13)
	# TODO(jgrafton): update to 1.11.2b4 when available
	GO_VERSION = 1.11b4
	BAZEL = 0.18.0
endif
ifeq ($(K8S), 1.12)
	GO_VERSION = 1.10.4b4
	BAZEL = 0.16.1
endif
ifeq ($(K8S), 1.11)
	GO_VERSION = 1.10.3b4
	BAZEL = 0.14.0
endif
ifeq ($(K8S), 1.10)
	GO_VERSION = 1.9.3b4
	BAZEL = 0.14.0
endif
ifeq ($(K8S), 1.9)
	GO_VERSION = 1.9.3b4
	BAZEL = 0.14.0
	# No longer being built upstream
	BASE_TAG = v20181031-56c4485dc
endif

all: all-build

sub-build-%:
	$(MAKE) K8S=$* build

all-build: $(addprefix sub-build-,$(ALL_K8S))

build:
	@echo Building with go:$(GO_VERSION) bazel:$(BAZEL)
	docker build --build-arg BASEIMAGE=$(BASE_IMG):$(BASE_TAG)-$(K8S) \
		--build-arg GO_URL_BASE=$(GO_URL_BASE) \
		--build-arg GO_VERSION=$(GO_VERSION) \
		--build-arg IMAGE=$(FULL_IMG) \
		--build-arg BAZEL_VERSION_ARG=$(BAZEL) \
		-t $(FULL_IMG) .
	docker tag $(FULL_IMG) $(IMG):latest-$(K8S)
	@echo Built $(FULL_IMG) and tagged with latest-$(K8S)

sub-push-%:
	$(MAKE) K8S=$* push

all-push: $(addprefix sub-push-,$(ALL_K8S))

push: build
	docker push $(FULL_IMG)
	docker push $(IMG):latest-$(K8S)
	@echo Pushed $(IMG) with :latest-$(K8S) and :$(TAG)-$(K8S) tags

.PHONY: all all-build all-push build push sub-build-% sub-push-%