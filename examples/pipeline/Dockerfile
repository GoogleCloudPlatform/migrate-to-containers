FROM python:3.9.2-alpine

ARG KUBE_VERSION=v1.20.4

RUN apk add --no-cache curl \
    && curl -L "https://dl.k8s.io/release/$KUBE_VERSION/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && pip3 install --no-cache pyyaml jsonpatch
