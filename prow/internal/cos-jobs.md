This readme documents the COS jobs defined in config.yaml.

# Purpose
COS team runs the k8s e2e tests as part of their continuous integration. As we
do releases on mutliple branches, we set up multiple integration jobs. All these
jobs will have `gci-qa-` in their names. `gci` is the old name of COS and `qa`
stands for Quality Assurance.

# Setup
So far we run three suites of k8s e2e tests: Basic, Serial and Slow. The
specifications of each suite can be found at the `--test_args` arg to kubetest
in their job configurations. For example, the basic suite _skips_ [Slow],
[Serial], [Disruptive], [Flaky] and [Feature] while the serial suite _focuses_
on [Serial] and [Disruptive] tests.

For each suite, we typically keep four jobs: one for the COS master branch, and
one each for the three most recent COS branches. For example, if master is at
m68, we will keep m67, m66, and m65.

# COS and Kubernetes Version
These are COS QA tests, so COS' built-in Kubernetes version is selected when
starting the test cluster. This is controlled by the `--extract` flag to
kubetest. For example, for the basic suite on the master branch, we have
`--extract=gci/gci-canary`. The prefix `gci` tells kubetest to use COS built-in
version. It gets that version from `gci-canary`, which is an image family in the
`container-vm-image-staging` project. When starting the test cluster, kubetest
will set both the master and node image to the one pointed to by the
`gci-canary` family. It gets the desired Kubernetes version by looking up the
COS image name in a GCS bucket: gs://container-vm-image-staging/k8s-version-map.
Similarly, for the m67 branch, we will set `--extract` to `gci/gci-m67`.

## Unknown Tricks
A less documented feature supported by the extract magic is a second backslash.
For example, you may find settings like `--extract=gci/gci-65/1.8-latest`. The
text after the second backslash tells kubetest to extract (download) the latest
Kubernetes CI version on the 1.8 branch. We occasionally have to do this because
there might be known problems with the COS built-in k8s version, yet it is so
subtle that there isn't a patched release yet for COS to upgrade to. Because COS
tries to stay up to the latest with k8s upgrade, the difference between a
built-in version and the latest CI version on a release branch should be small
enough that we can consider the integration tests credible.

# Project Pool - Boskos
COS jobs use Boskos too. The project pool is `gci-qa-project`.

# gci-ci- Jobs
There are three more jobs in addition to the `gci-qa-*` ones, and they all have
the substring `gci-ci-` in their name. The `ci` bits indicate that these are
used for continuous integration between COS and Kubernetes. At each test run,
the latest COS build and the latest Kubernetes CI version are used to start the
test cluster. These are controlled by the `--extract=gci/gci-canary/latest` arg
to kubetest.

These jobs give us an early signal of how likely the parallel developments of
COS and Kubernetes are going to break each other.

# Docker Validation Test Jobs
Jobs with "cos-docker-validation" in their names also belong to COS team. While
initially designed to qualify up-coming docker upgrades in COS, they are being
used to qualify other package upgrades like the kernel, systemd,
compute-image-package, etc. They are very similar to the `gci-qa-` equivalents
except that they all use the `gci-next-canary` image family, as opposed to
`gci-canary`.
