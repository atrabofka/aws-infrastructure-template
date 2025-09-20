<!-- omit in toc -->
# AWS Infrastructure Template

- [🧱 Core Principles](#-core-principles)
- [🌳 Directory Structure](#-directory-structure)
- [📖 Workflow](#-workflow)
  - [Infrastructure Management (Terraform \& Terragrunt)](#infrastructure-management-terraform--terragrunt)
  - [Application Deployment (Helm \& ArgoCD)](#application-deployment-helm--argocd)
  - [Tagging](#tagging)
- [🛠️ Setup](#️-setup)
  - [Manual AWS Setup](#manual-aws-setup)
  - [Configure Your Local Environment](#configure-your-local-environment)
- [💻 Usage](#-usage)
  - [Lifecycle commands](#lifecycle-commands)
  - [Utility commands](#utility-commands)

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
├── Makefile             # Project Makefile for common tasks
├── bootstrap/           # Boilerplate configurations for manual AWS setup
├── terraform/           # All Terragrunt and Terraform configurations
│   ├── live/            # Environment-specific infrastructure configs
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
└── helm/                # All application deployment settings
│   ├── charts/          # Reusable Helm charts
│   │   ├── my-app/      # Base chart for a specific application
│   │   └── prometheus/  # Common third-party charts
│   └── live/            # Environment-specific applications
│       ├── qa/
│       │   └── my-app.yaml  # Environment-specific values for  `my-app`
|       └── prod/
|           └── my-app.yaml
```

## 📖 Workflow

### Infrastructure Management (Terraform & Terragrunt)

Location: `terraform/live/`

Purpose: To deploy and manage foundational infrastructure such as VPCs, networking components, databases, and EKS clusters. This layer is managed using terragrunt run-all commands.

### Application Deployment (Helm & ArgoCD)

Location: `helm/live/`

Purpose: To manage application deployments and their configurations. These directories are monitored by ArgoCD, which automatically syncs any changes to the respective Kubernetes clusters, ensuring a seamless GitOps workflow.

### Tagging

Consistent and accurate tagging is a mandatory requirement for all AWS resources provisioned by our company. This policy enables accurate cost allocation, improves resource management, and strengthens our security posture. Please see the mandatory and optional tags below.

Mandatory tags
| Tag Key | Description | Example Values |
| :--- | :--- | :--- |
| **`Name`** | A unique, human-readable name for the resource. | `api-gateway-prod-customers`, `lambda-user-profile`, `s3-docs-project-alpha` |
| **`Application`** | The specific application or project the resource belongs to. | `project-alpha`, `internal-crm`, `billing-service`, `client-portal` |
| **`Owner`** | The name or alias of the individual or team responsible for the resource. | `janedoe`, `team-b`, `infrastructure-team` |
| **`CostCenter`** | The high-level department or business unit that the resource's cost should be allocated to. | `software-engineering`, `marketing`, `data-science` |
| **`ManagedBy`** | The name of the team or tool responsible for the technical management and lifecycle of the resource. | `terraform`, `cloudformation`, `devops-team` |

Optional tags
| Tag Key | Description | Example Values |
| :--- | :--- | :--- |
| **`Environment`** | The deployment environment of the resource. |	`prod`, `dev`, `test`, `staging` |
| **`Lifecycle`** |	The life stage or automation policy for a resource.	| `persistent`, `ephemeral`, `review-date:2025-12-31` |
| **`Automation`** | A flag for automated scripts to include or exclude a resource.	| `no-stop`, `no-delete` |
| **`Compliance`** | The security or regulatory compliance level of the resource. | `internal`, `pci`, `hipaa`, `confidential` |

## 🛠️ Setup

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

## 💻 Usage

### Lifecycle commands

The Makefile uses pattern rules to run Terragrunt commands on a specific environment. Replace [env] with the desired environment name (e.g., dev, staging, prod).

**Initialize:** Initializes Terragrunt and the Terraform backend for the specified environment.
```sh
make init-<env>
```

**Plan:** Generates a plan showing what changes will be made to the infrastructure.
```sh
make plan-<env>
```

**Apply:** Applies the planned changes to the infrastructure.
```sh
make apply-<env>
```

**Validate:** Validates the Terragrunt and Terraform code for syntax and logical consistency.
```sh
make validate-<env>
```

### Utility commands

The Makefile includes several utility commands for maintenance and development. These commands do not require AWS credentials to run.

**Clean:** Removes all Terragrunt caches and local Terraform files (.terragrunt-cache/, .terraform/, and .terraform.lock.hcl) for a specified environment. This is useful for troubleshooting.
```sh
make clean-<env>
```