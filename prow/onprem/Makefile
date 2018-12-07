PROJECT ?= syllogi-ci
IMAGE ?= syllogi-testing
TAG ?= experimental
JOB_NAMESPACE ?= test-pods

.PHONY: update-config
update-config: get-cluster-credentials
	kubectl create configmap config --from-file=config.yaml=config.yaml --dry-run -o yaml | kubectl replace configmap config -f -

.PHONY: update-job-config
update-job-config: get-cluster-credentials
	kubectl create configmap job-config --from-file=job-config.yaml=job-config.yaml --dry-run -o yaml | kubectl replace configmap job-config -f -

.PHONY: update-cluster
update-cluster: get-cluster-credentials
	kubectl apply -f cluster.yaml

# Note: you need to have the credentials to the cluster.
.PHONY: get-cluster-credentials
get-cluster-credentials:
	kubectl config use-context vsphere-prow

.PHONY: create-image
create-image:
	docker build -t $(IMAGE):$(TAG) -f Dockerfile .

.PHONY: update-image
update-image:
	gcloud auth configure-docker
	docker tag $(IMAGE):$(TAG) gcr.io/$(PROJECT)/$(IMAGE):$(TAG)
	docker push gcr.io/$(PROJECT)/$(IMAGE):$(TAG)

.PHONY: update-boskos
update-boskos: get-cluster-credentials
	kubectl apply -f boskos/boskos.yaml

.PHONY: update-boskos-config
update-boskos-config: get-cluster-credentials
	kubectl create configmap resources --from-file=config=boskos/resources.yaml --dry-run -o yaml | kubectl --namespace="$(JOB_NAMESPACE)" replace configmap resources -f -