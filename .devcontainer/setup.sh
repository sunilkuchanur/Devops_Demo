#!/bin/bash

set -e

echo "======================================"
echo " DevOps Demo Environment Setup"
echo "======================================"

echo "[1/4] Installing kind..."

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

echo "[2/4] Installing useful tools..."

sudo apt-get update
sudo apt-get install -y jq tree make

echo "[3/4] Checking installations..."

echo "Git:"
git --version

echo "Docker:"
docker --version

echo "kubectl:"
kubectl version --client

echo "Helm:"
helm version

echo "Terraform:"
terraform version

echo "AWS CLI:"
aws --version

echo "kind:"
kind version

echo "[4/4] Environment ready."

echo ""
echo "======================================"
echo " Run: make cluster"
echo "======================================"
