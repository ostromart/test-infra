SERVICE_ACCOUNT_KEY_FILE  ?= service-account-key-file
HUB                ?= gcr.io/gob-prow
TAG                ?= latest

GKE_TEST_INFRA = docker/gke-internal
OSS_TEST_INFRA = docker/k8s

gather-files: clean
	mkdir -p ./docker/bin ./docker/config ./docker/.secret

	# Checkout gob prow config.yaml

	mkdir -p "${GKE_TEST_INFRA}"
	git clone sso://gke-internal.googlesource.com/test-infra "${GKE_TEST_INFRA}"
	# Add echo test into config.yaml
	cat echo-test.yaml >> "${GKE_TEST_INFRA}"/prow/gob/config.yaml
	cp "${GKE_TEST_INFRA}"/prow/gob/config.yaml "${GKE_TEST_INFRA}"/prow/gob/Makefile docker/config/

	# Checkout and build mkpj

	mkdir -p "${OSS_TEST_INFRA}"
	git clone https://github.com/kubernetes/test-infra "${OSS_TEST_INFRA}"
	cd "${OSS_TEST_INFRA}" && bazel build //prow/cmd/mkpj:mkpj && cd -
	cp "${OSS_TEST_INFRA}"/bazel-bin/prow/cmd/mkpj/linux_amd64_stripped/mkpj docker/bin

	cp ./trigger.sh ./docker/bin/
	cp $(SERVICE_ACCOUNT_KEY_FILE) ./docker/.secret/service-account-key-file

build-docker:
	docker build -t "$(HUB)"/prow-trigger:"$(TAG)" .

push-docker:
	docker push "$(HUB)"/prow-trigger:"$(TAG)"

clean:
	rm -rf docker

build: clean gather-files build-docker

all: build push clean

local-test:
	docker run -e "PUBSUB_PROJECT=gke-release" -e "PUBSUB_TOPIC=louhi-prow" -e "PUBSUB_RUNID=abc123" -e "PROW_JOB=echo-test" -it "$(HUB)"/prow-trigger:"$(TAG)" /bin/bash