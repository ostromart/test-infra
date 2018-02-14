# These are the usual GKE variables.
PROJECT       ?= gke-prow
BUILD_PROJECT ?= gke-prow
ZONE          ?= us-central1-f
CLUSTER       ?= prow

.PHONY: update-config
update-config: get-cluster-credentials
	kubectl create configmap config --from-file=config=config.yaml --dry-run -o yaml | kubectl replace configmap config -f -

.PHONY: update-plugins
update-plugins: get-cluster-credentials
	kubectl create configmap plugins --from-file=plugins=plugins.yaml --dry-run -o yaml | kubectl replace configmap plugins -f -

.PHONY: update-cluster
update-cluster: get-cluster-credentials
	kubectl apply -f cluster.yaml

.PHONY: create-secrets
create-secrets: get-cluster-credentials
	@echo ""
ifeq ("","$(OAUTH_FILE)")
	@echo "Specify \$$(OAUTH_FILE) to create the oauth-token secret."
else
	@echo "Creating oauth-token secret from file: $(OAUTH_FILE)"
	kubectl delete secret oauth-token || true
	kubectl create secret generic oauth-token --from-file=oauth="$(OAUTH_FILE)"
endif
ifeq ("","$(HMAC_FILE)")
	@echo "Specify \$$(HMAC_FILE) to create the hmac-token secret."
else
	@echo "Creating hmac-token secret from file: $(HMAC_FILE)"
	kubectl delete secret hmac-token || true
	kubectl create secret generic hmac-token --from-file=hmac="$(HMAC_FILE)"
endif

.PHONY: get-cluster-credentials
get-cluster-credentials:
	gcloud container clusters get-credentials "$(CLUSTER)" --project="$(PROJECT)" --zone="$(ZONE)"
