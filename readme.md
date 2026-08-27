devops-reusability-demo/
│
├── .devcontainer/
│   └── devcontainer.json
│
├── scripts/
│   ├── deploy.sh
│   ├── destroy.sh
│   └── health-check.sh
│
├── docker/
│   ├── Dockerfile
│   └── app/
│       └── index.html
│
├── kubernetes/
│   ├── base/
│   │   ├── namespace.yaml
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── network-policy.yaml
│   │
│   └── overlays/
│       ├── dev/
│       │   └── kustomization.yaml
│       └── prod/
│           └── kustomization.yaml
│
├── terraform/
│   ├── modules/
│   │   └── storage/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   ├── environments/
│   │   ├── dev/
│   │   │   ├── main.tf
│   │   │   └── terraform.tfvars
│   │   └── prod/
│   │       ├── main.tf
│   │       └── terraform.tfvars
│
├── jenkins/
│   ├── Jenkinsfile
│   └── vars/
│       └── deployApp.groovy
│
├── shell/
│   ├── config.env
│   └── deploy.sh
│
├── README.md
└── Makefile
