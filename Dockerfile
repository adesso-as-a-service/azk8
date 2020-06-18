FROM mcr.microsoft.com/azure-cli:latest

ARG HELM_VERSION="3.2.4"
ARG HELM_PLUGIN_VERSION="0.0.7"

RUN apk add --update -t deps \
      ca-certificates \
      curl \
      git \
      openssl

RUN curl -Ls https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
      -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

RUN curl -Ls https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 \
      -o /usr/local/bin/skaffold \
 && chmod +x /usr/local/bin/skaffold

RUN curl -Ls https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
      -o helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && tar -xf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin \
 && rm -f /helm-v${HELM_VERSION}-linux-amd64.tar.gz

RUN curl -Ls https://github.com/adesso-as-a-service/helm-local-chart-version/releases/download/v${HELM_PLUGIN_VERSION}/helm-local-chart-version-${HELM_PLUGIN_VERSION}-linux-amd64.tar.gz \
      -o /tmp/helm-local-chart-version-${HELM_PLUGIN_VERSION}-linux-amd64.tar.gz \
 && cd /usr/local/bin \
 && tar -zxf /tmp/helm-local-chart-version-${HELM_PLUGIN_VERSION}-linux-amd64.tar.gz local-chart-version \
 && rm /tmp/helm-local-chart-version-${HELM_PLUGIN_VERSION}-linux-amd64.tar.gz

RUN apk del --purge deps \
 && rm /var/cache/apk/*
