# These are the usual GKE variables.
PROJECT       ?= gke-prow
BUILD_PROJECT ?= gke-prow
ZONE          ?= us-central1-f
CLUSTER       ?= prow

update-config: get-cluster-credentials
	kubectl create configmap config --from-file=config=config.yaml --dry-run -o yaml | kubectl replace configmap config -f -

update-cluster: get-cluster-credentials
	kubectl apply -f cluster.yaml

get-cluster-credentials:
	gcloud container clusters get-credentials "$(CLUSTER)" --project="$(PROJECT)" --zone="$(ZONE)"

.PHONY: update-config update-cluster get-cluster-credentials