FROM mcr.microsoft.com/azure-cli:latest

ARG KUSTOMIZE_VERSION="3.8.2"
ARG HELM_VERSION="3.3.1"
ARG HELM_PLUGIN_VERSION="0.0.7"

RUN apk add --update -t deps \
      ca-certificates \
      curl \
      git \
      openssl

RUN az aks install-cli

RUN curl -Ls --remote-name https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz \
 && tar -xzf kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz -C /usr/local/bin \
 && rm kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz

RUN curl -Ls https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 \
      -o /usr/local/bin/skaffold \
 && chmod +x /usr/local/bin/skaffold

RUN curl -Ls --remote-name https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && tar -xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz linux-amd64/helm --strip-components 1 -C /usr/local/bin \
 && rm -f helm-v${HELM_VERSION}-linux-amd64.tar.gz

RUN curl -Ls --remote-name https://github.com/adesso-as-a-service/helm-local-chart-version/releases/download/v${HELM_PLUGIN_VERSION}/helm-local-chart-version-${HELM_PLUGIN_VERSION}-linux-amd64.tar.gz \
 && tar -xzf helm-local-chart-version-${HELM_PLUGIN_VERSION}-linux-amd64.tar.gz -C /usr/local/bin \
 && rm helm-local-chart-version-${HELM_PLUGIN_VERSION}-linux-amd64.tar.gz

RUN apk del --purge deps \
 && rm /var/cache/apk/*
