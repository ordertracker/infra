# Infrastructure

This repo contains Terraform code for deploying Kubernetes cluster on DigitalOcean, preparing the cluster for dpeloying applications and pipeline for the Ordertracker API service.

## Terraform

The Kubernetes cluster is initialized using the Terraform `k8s` module, based on the ENV variables saved in the .env file, a Kubernetes cluster will be launched on DigitalOcean.

## Scripts

Few several scripts are presented on the repo for:

- Initializing the infrastructure
- Scaling the infrastructure
- Destroying the infrastructure

## Tektoncd

The Tekton Pipelines project provides k8s-style resources for declaring CI/CD-style pipelines. In the `pipelines/` directory we have Kubernetes manifest files for setting up:

- Pipeline Resources
- Pipeline
- Tasks
- PipelineRun for executing the created Pipeline

## Usage

For initializing the infrastructure use:
```
make init
```

For scaling the infrastructure use:
```
make scale NODES=<number-of-nodes> SIZE=<node-size>
```

For destroying the infrastructure use:
```
make destroy
```
