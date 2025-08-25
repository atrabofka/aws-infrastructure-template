# AWS Infrastructure Template

1. [Core Principles](#core-principles)  
2. [Directory Structure](#directory-structure)
3. [Workflow](#workflow)
4. [Getting Started](#getting-started)

This repository serves as the single source of truth for our cloud infrastructure and application deployments. It is organized to follow modern Infrastructure as Code (IaC) and GitOps best practices, ensuring a clear separation of concerns, reusability, and consistency across all environments.

## 🧱 Core Principles
The repository is built on three core principles:

- IaC (Infrastructure as Code): All infrastructure is defined and managed in a declarative way using Terraform and Terragrunt.
- GitOps: All application deployments are managed via a Git-centric workflow using Helm and ArgoCD, ensuring that the desired state in Git matches the state in the cluster.
- DRY (Don't Repeat Yourself): Reusable code (Terraform modules and Helm charts) is centralized to minimize duplication and simplify maintenance.

## 🌳 Directory Structure
The repository is organized into two primary, top-level directories: terraform and helm, reflecting the separation between infrastructure and applications.

```
.
├── .github/             # GitHub Actions for CI/CD pipelines
├── .gitignore
├── README.md            # This README file
├── Makefile             # Makefile for assisting 
├── terraform/           # All Terragrunt and Terraform configurations
│   ├── live/            # "Live" configurations for each environment
│   │   ├── qa/
│   │   │   ├── networking/
│   │   │   ├── vpc/
│   │   │   └── terragrunt.hcl
│   │   └── prod/
│   │       ├── networking/
│   │       └── vpc/
│   │       └── terragrunt.hcl
│   └── modules/         # Reusable Terraform modules
│       ├── vpc/
│       │   └── main.tf
│       └── eks/
└── helm/                # All application configurations
│   ├── charts/          # Reusable Helm charts
│   │   ├── my-app/      # Base chart for a specific application
│   │   └── prometheus/  # Common third-party charts
│   └── live/            # "Live" configurations for each environment
│       ├── qa/
│       │   └── my-app.yaml  # Environment-specific values for  `my-app`
|       └── prod/
|           └── my-app.yaml
└── bootstrap/            # Boilerplate configurations for manual AWS setup
```

## 🚀 Workflow

### Infrastructure Management (Terraform & Terragrunt)

Location: `terraform/live/`

Purpose: To deploy and manage foundational infrastructure such as VPCs, networking components, databases, and EKS clusters. This layer is managed using terragrunt run-all commands.

### Application Deployment (Helm & ArgoCD)

Location: `helm/live/`

Purpose: To manage application deployments and their configurations. These directories are monitored by ArgoCD, which automatically syncs any changes to the respective Kubernetes clusters, ensuring a seamless GitOps workflow.

## 🛠️ Getting Started

To ensure a consistent and reproducible environment, all IaC commands should be run within the custom-built Docker image.

### Manual AWS Setup

These resources are the foundation of our infrastructure and must be created manually in the AWS Console. Make sure they are in place for the corresponding AWS account before running the IaC.

**S3 Bucket for Terraform State**

* **Name:** `<aws-account-id>-<company>-iac-terraform-state`
* **Settings:**
    * Enable Versioning.
    * Enable Default encryption (AES-256).
    * Ensure Block all public access is enabled.
    * ACLs disabled.

**DynamoDB Table for State Locking**

* **Name:** `<company>-iac-terraform-locks`
* **Settings:**
    * Partition key: `LockID`
    * Partition key type: `String`

**IAM role for the CI/CD Pipeline**

* **Name**: `<company>-iac-terraform-builder`
* **Trusted Entity:**
    * Create a custom trust policy for the GitHub OIDC provider.
    * The trust policy will allow `token.actions.githubusercontent.com` to assume the role, with a condition that restricts it to your specific GitHub repository.
    * Please refer to the `./bootstrap/iac-terraform-builder-trust-policy.json` for example structure.
* **Permissions:**
    * Attach a permissions policy that grants access to your ECR registry (`ecr:*`), the S3 bucket and DynamoDB table we created (`s3:*`, `dynamodb:*`), and the ability to assume other IAM roles via `sts:AssumeRole`.
    * Please refer to the `./bootstrap/iac-terraform-builder-policy.json` for example structure.

### Configure Your Local Environment

Ensure you have Docker installed and your AWS credentials configured locally.

### Usage

Build the Docker Image:

```sh
docker build -t zealops/terragrunt:aws-latest .
```

Run a `command` using the image for some `environment`:

```sh
docker run --rm -it \
    -v "$(pwd)/terraform/live/<environment>":/app/live/env \
    -v "$(pwd)/terraform/modules":/app/modules \
    -w /app/live/env \
    zealops/terragrunt:aws-latest <command>
```

Running commands via Makefile (simplified usage)
```sh
make plan-<env>
make apply-<env>
make validate-<env>
```
