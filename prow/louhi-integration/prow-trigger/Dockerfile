FROM debian:jessie

# common util tools
# https://github.com/GoogleCloudPlatform/gsutil/issues/446 for python-openssl
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    vim \
    python \
    python-dev \
    python-openssl \
    python-pip \
    wget \
    && apt-get clean \
    && python -m pip install --upgrade pip setuptools wheel

# Install gcloud
ENV PATH=/google-cloud-sdk/bin:/workspace:${PATH} \
    CLOUDSDK_CORE_DISABLE_PROMPTS=1

RUN wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz && \
    tar xzf google-cloud-sdk.tar.gz -C / && \
    rm google-cloud-sdk.tar.gz && \
    /google-cloud-sdk/install.sh \
        --disable-installation-options \
        --bash-completion=false \
        --path-update=false \
        --usage-reporting=false && \
    gcloud components install alpha beta kubectl && \
    gcloud info

COPY ./docker/bin /usr/local/bin

COPY ./docker/config /usr/local/config

COPY ./docker/.secret /usr/local/.secret

CMD ["/usr/local/bin/trigger.sh"]
