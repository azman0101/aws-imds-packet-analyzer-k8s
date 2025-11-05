#!/usr/bin/env bash
set -eu

IMAGE="${1:-ghcr.io/azman0101/aws-imds-packet-analyzer:latest}"

echo "Building image: $IMAGE"
docker build -t "$IMAGE" .

echo "Built $IMAGE"

echo "To push: docker push $IMAGE"

echo "To deploy the DaemonSet: kubectl apply -f daemonset.yaml"
