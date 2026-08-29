Plain YAML — starting point

Suppose we have:

k8s/
├── deployment.yaml
├── service.yaml
└── configmap.yaml

The deployment contains:

replicas: 2

containers:
  - name: myapp
    image: myapp:1.0

This is easy to understand.

But if production needs:

replicas: 5

while development needs:

replicas: 1

you may start duplicating files.

That's the maintainability problem.

5. Kustomize — reuse without copying everything

Kustomize allows us to maintain a base configuration and apply environment-specific changes.

Structure:

k8s/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
│
└── overlays/
    ├── dev/
    │   ├── kustomization.yaml
    │   └── replica-patch.yaml
    │
    └── prod/
        ├── kustomization.yaml
        └── replica-patch.yaml

Think of it like:

                 BASE
                  |
        ┌─────────┴─────────┐
        ↓                   ↓
       DEV                 PROD
     customize           customize

The base contains common configuration.

The overlay contains environment-specific differences.

6. Example
Base Deployment
apiVersion: apps/v1
kind: Deployment

metadata:
  name: myapp

spec:
  replicas: 2

  selector:
    matchLabels:
      app: myapp

  template:
    metadata:
      labels:
        app: myapp

    spec:
      containers:
        - name: myapp
          image: myapp:1.0

Then production can modify only what it needs:

apiVersion: apps/v1
kind: Deployment

metadata:
  name: myapp

spec:
  replicas: 5

So we don't copy the entire Deployment.

That's reusability + maintainability.

====================================================================================================================

7. Helm — another major approach

Helm takes templating further.

Instead of hardcoding:

replicas: 2
image: myapp:1.0

we can write:

replicas: {{ .Values.replicaCount }}

image: {{ .Values.image.repository }}:{{ .Values.image.tag }}

Then define values separately:

replicaCount: 2

image:
  repository: myapp
  tag: "1.0"

Production could have:

replicaCount: 5

image:
  repository: myapp
  tag: "2.0"

Same template.

Different values.

8. Helm structure

A typical Helm chart:

myapp/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    └── configmap.yaml

Think of it as:

             Helm Template
                   |
          ┌────────┼────────┐
          ↓        ↓        ↓
        DEV       QA       PROD
          |        |        |
      values-dev values-qa values-prod
