# Kubernetes – Automation, Reusability and Maintainability

Kubernetes manifests define the desired state of applications running in a Kubernetes cluster.

As applications grow, maintaining multiple YAML files for different environments can become difficult.

Kustomize and Helm help us make Kubernetes configurations more automated, reusable, and maintainable.

---

# Plain YAML — Starting Point

Suppose we have:

```text
k8s/
├── deployment.yaml
├── service.yaml
└── configmap.yaml
