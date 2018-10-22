# These are the usual GKE variables.
# google-oss-prow
PROJECT       ?= solar-climber-220218
# google-oss-prow
BUILD_PROJECT ?= solar-climber-220218
ZONE          ?= us-west1-a
CLUSTER       ?= prow
JOB_NAMESPACE ?= test-pods

.PHONY: update-config
update-config: get-cluster-credentials
	kubectl create configmap config --from-file=config.yaml=config.yaml --dry-run -o yaml | kubectl replace configmap config -f -

.PHONY: update-cluster
update-cluster: get-cluster-credentials
	kubectl apply -f cluster.yaml
	kubectl apply -f grandmatriarch.yaml
	kubectl apply -f cert-manager.yaml

.PHONY: get-cluster-credentials
get-cluster-credentials:
	gcloud container clusters get-credentials "$(CLUSTER)" --project="$(PROJECT)" --zone="$(ZONE)"
