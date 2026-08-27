#!/bin/bash

set -e

source "$(dirname "$0")/config.env"

echo "Deploying application..."
echo "Application : $APP_NAME"
echo "Namespace   : $NAMESPACE"
echo "Replicas    : $REPLICAS"

kubectl apply -k kubernetes/overlays/dev

kubectl scale deployment "$APP_NAME" \
  --replicas="$REPLICAS" \
  --namespace="$NAMESPACE"

echo "Deployment completed."

kubectl get pods \
  --namespace="$NAMESPACE"