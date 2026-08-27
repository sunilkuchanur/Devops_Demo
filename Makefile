.PHONY: help cluster delete deploy status logs destroy

help:
	@echo ""
	@echo "DevOps Reusability Demo"
	@echo ""
	@echo "Available commands:"
	@echo "  make cluster   Create Kubernetes cluster"
	@echo "  make deploy    Deploy application"
	@echo "  make status    Show application status"
	@echo "  make logs      Show application logs"
	@echo "  make destroy   Delete application"
	@echo "  make delete    Delete Kubernetes cluster"
	@echo ""

cluster:
	kind create cluster --name devops-demo --wait 60s

deploy:
	kubectl apply -k kubernetes/overlays/dev

status:
	kubectl get all -n devops-demo

logs:
	kubectl logs -n devops-demo -l app=demo-app

destroy:
	kubectl delete -k kubernetes/overlays/dev

delete:
	kind delete cluster --name devops-demo