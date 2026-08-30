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
```

The Deployment contains:

```yaml
replicas: 2

containers:
  - name: myapp
    image: myapp:1.0
```

This is easy to understand.

But if production needs:

```yaml
replicas: 5
```

while development needs:

```yaml
replicas: 1
```

you may start duplicating files.

For example:

```text
k8s/
├── dev/
│   └── deployment.yaml
└── prod/
    └── deployment.yaml
```

Now the same Kubernetes configuration exists in multiple places.

If the application configuration changes, we may need to update multiple files.

That's the maintainability problem.

---

# 5. Kustomize — Reuse Without Copying Everything

Kustomize allows us to maintain a base configuration and apply environment-specific changes.

## Structure

```text
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
```

Think of it like:

```text
                 BASE
                  |
        ┌─────────┴─────────┐
        ↓                   ↓
       DEV                 PROD
     customize           customize
```

The base contains common configuration.

The overlay contains environment-specific differences.

This allows us to reuse the same base configuration without copying the entire Kubernetes manifest.

---

# 6. Kustomize Example

## Base Deployment

```yaml
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
```

Then production can modify only what it needs:

```yaml
apiVersion: apps/v1
kind: Deployment

metadata:
  name: myapp

spec:
  replicas: 5
```

We don't need to copy the entire Deployment.

The base is reused, and only the required production-specific value is changed.

That's reusability + maintainability.

## Kustomize Concept

```text
                    BASE
                     |
          ┌──────────┴──────────┐
          ↓                     ↓
         DEV                   PROD
          |                     |
     replicas: 1           replicas: 5
          |                     |
          └──────────┬──────────┘
                     ↓
              Same application
              configuration
```

Kustomize allows us to keep common configuration in the base and customize it for different environments using overlays.

---

# 7. Helm — Another Major Approach

Helm takes templating further.

Instead of hardcoding:

```yaml
replicas: 2

image: myapp:1.0
```

we can write:

```yaml
replicas: {{ .Values.replicaCount }}

image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
```

Then define values separately:

```yaml
replicaCount: 2

image:
  repository: myapp
  tag: "1.0"
```

Production could have:

```yaml
replicaCount: 5

image:
  repository: myapp
  tag: "2.0"
```

The same template can be reused with different values.

```text
Same Template
      |
      ├── Development Values
      |
      ├── QA Values
      |
      └── Production Values
```

This means:

**Same template + Different values = Different environments**

---

# 8. Helm Structure

A typical Helm chart looks like:

```text
myapp/
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    └── configmap.yaml
```

Think of it as:

```text
             Helm Template
                   |
          ┌────────┼────────┐
          ↓        ↓        ↓
        DEV       QA       PROD
          |        |        |
       values-   values-  values-
         dev       qa       prod
```

The Helm templates contain the common Kubernetes configuration.

The values files contain environment-specific configuration.

---

# Kustomize vs Helm

| Feature | Kustomize | Helm |
|---|---|---|
| Approach | Overlay-based customization | Template-based configuration |
| Base configuration | Uses a base | Uses templates |
| Environment changes | Overlays and patches | Values files |
| Templating | No template language required | Uses Helm templates |
| Reusability | Reuses Kubernetes YAML | Reuses templates |
| Maintainability | Centralized base + overlays | Centralized templates + values |
| Complexity | Relatively simple | More powerful and flexible |

---

# Automation + Reusability + Maintainability

```text
                    Kubernetes
                         |
             ┌───────────┴───────────┐
             ↓                       ↓
         Kustomize                  Helm
             |                       |
             ↓                       ↓
       Base + Overlays         Templates + Values
             |                       |
             └───────────┬───────────┘
                         ↓
                 Reusable Configuration
                         |
                         ↓
                  Multiple Environments
                         |
                         ↓
              Automation + Maintainability
```

---

# Why Use Kustomize?

## Without Kustomize

```text
Development YAML
        +
Production YAML
        +
QA YAML
        ↓
Duplicated configuration
```

## With Kustomize

```text
             Base
              |
       ┌──────┼──────┐
       ↓      ↓      ↓
      Dev     QA    Prod
    Overlay Overlay Overlay
```

## Benefits

- Less duplication
- Reusable base configuration
- Environment-specific customization
- Easier maintenance
- Easier configuration management

---

# Why Use Helm?

Without Helm, we may need separate YAML files for different environments.

With Helm:

```text
              Helm Templates
                    |
             ┌──────┼──────┐
             ↓      ↓      ↓
            DEV     QA    PROD
             |      |      |
          Values   Values  Values
```

The same templates can be reused across multiple environments.

## Benefits

- Reusable templates
- Environment-specific values
- Easier application packaging
- Versioning of application configurations
- Easier deployment and upgrades

---

# Presentation Explanation

Plain Kubernetes YAML is easy to understand, but maintaining separate YAML files for every environment can lead to duplication.

Kustomize solves this by allowing us to maintain a common base configuration and apply environment-specific changes through overlays.

For example, the base Deployment may have two replicas, while the production overlay changes only the replica count to five.

Helm takes a different approach. It uses templates and values. Instead of hardcoding values such as replica counts and image versions, we define placeholders in the templates and provide different values for development, QA, and production.

So Kustomize mainly focuses on customizing existing Kubernetes YAML, while Helm focuses on templating and packaging Kubernetes applications.

Both approaches help improve reusability and maintainability.

---

# Kustomize vs Helm — Simple Understanding

## Kustomize

```text
Base YAML
    +
Environment Overlay
    ↓
Customized Kubernetes YAML
```

## Helm

```text
Template
    +
Values
    ↓
Generated Kubernetes YAML
```

A simple way to remember:

**Kustomize = Customize YAML**

**Helm = Template + Values**

---

# Final Summary

Kubernetes configuration can become difficult to maintain when multiple environments require different settings.

Kustomize helps by using:

- Base configurations
- Overlays
- Patches

Helm helps by using:

- Templates
- Values
- Charts

Both approaches reduce duplication and allow us to reuse common configuration.

```text
             Kubernetes Manifests
                     |
            ┌────────┴────────┐
            ↓                 ↓
        Kustomize            Helm
            |                 |
       Base + Overlay    Template + Values
            |                 |
            └────────┬────────┘
                     ↓
               Reusability
                     +
               Maintainability
                     ↓
          Scalable Kubernetes
             Configuration
```

---

# Conclusion

Kustomize and Helm provide different approaches to managing Kubernetes configurations across multiple environments.

Kustomize is useful when we want to keep standard Kubernetes YAML and customize it using overlays.

Helm is useful when we need reusable templates, configurable values, packaging, and release management.

Both help us achieve **automation, reusability, and maintainability** in Kubernetes deployments.
