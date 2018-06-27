# These are the usual GKE variables.
PROJECT       ?= gob-prow
BUILD_PROJECT ?= gob-prow
ZONE          ?= us-west1-a
CLUSTER       ?= prow
JOB_NAMESPACE ?= test-pods

.PHONY: update-config
update-config: get-cluster-credentials
	kubectl create configmap config --from-file=config=config.yaml --dry-run -o yaml | kubectl replace configmap config -f -

.PHONY: update-cluster
update-cluster: get-cluster-credentials
	kubectl apply -f cluster.yaml

.PHONY: get-cluster-credentials
get-cluster-credentials:
	gcloud container clusters get-credentials "$(CLUSTER)" --project="$(PROJECT)" --zone="$(ZONE)"

.PHONY: update-boskos
update-boskos: get-cluster-credentials
	kubectl apply -f boskos/boskos.yaml

.PHONY: update-boskos-config
update-boskos-config: get-cluster-credentials
	kubectl create configmap resources --from-file=config=boskos/resources.yaml --dry-run -o yaml | kubectl --namespace="$(JOB_NAMESPACE)" replace configmap resources -f -
