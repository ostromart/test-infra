## Prow-trigger image

This image is used for docker based system like Louhi to trigger a prow job.


The following items are required in this image:

Binary:

* `mkpj`: The key tool to generated a deployable prowjob yaml based on a config.yaml.
mkpj is being built by `bazel` using latest `github.com/kubernetes/test-infra` in `make gather-files`.

* `kubectl`: The k8s cli tool to modify k8s resource and deploy yaml to cluster.
kubectl is installed through `gcloud` in Dockerfile

* `gcloud`: Google cloud cli to do authentication and fetch cluster credentials.
gcloud is installed in Dockerfile.

Config & secret:

* `config.yaml`: Prow config file, including cluster config and job config.
config.yaml is checked out from `gke-internal.googlesource.com/test-infra/` and
appended with echo-test.yaml for testing in `make gather-files`.

* `service-account-key-file`: The key file of prow cluster service account for authentication.
service-account-key-file needs to be provided by users in `make gather-files`.

* `trigger.sh`: Image entry script, it gets service account authenticated,
generate prowjob yaml, add extra Pub/Sub labels and deploy it into Prow cluster.

### Gather files
You can use `make gather-files` to gather `mkpj`, `config.yaml` and `make gather-files` into local folder `./docker/`.
This can help you make sure everything is as expected before being copied to image.

Example:
```bash
SERVICE_ACCOUNT_KEY_FILE=~/.secret/gob-prow-23a49d2acae7.json make gather-files
```

### Build image
You need to provide docker hub and tag. By default is `gcr.io/gob-prow` and `latest`.

Example:
```bash
HUB=docker.io/yutongz TAG=latest make build-docker
```

### Push image
Example:
```bash
make push-docker
```

### Test image locally
You can run image local or go inside of this image.

But we need to provide several environment variables to `trigger.sh`

Example:
```bash
make local-test
```
