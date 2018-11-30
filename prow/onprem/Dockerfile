FROM gcr.io/k8s-testimages/kubekins-e2e:v20180918-b58d77e83-1.11
LABEL maintainer="Amit Watve <amwat@google.com>"

WORKDIR /workspace
RUN mkdir -p /workspace
ENV WORKSPACE=/workspace \
    TERM=xterm

RUN apt-get install -y gettext
