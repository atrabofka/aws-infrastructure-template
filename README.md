# AWS Infrastructure Template

Generally inspired by:
- discussions with Vardan Ghazaryan  
- https://docs.rackspace.com/docs/fanatical-support-aws/managed-infra-as-code/tf_style  
- https://www.conventionalcommits.org/en/v1.0.0-beta.4/#:~:text=The%20Conventional%20Commits%20specification%20is,automated%20tools%20on%20top%20of  
- https://www.bacardi.com/

Usage of SHOULD, MUST etc. keywords in this document MUST be compliant to [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

1. [Structure](#structure)  
   1. [Modules](#modules)
   2. [Environment](#environment)
   3. [Branching](#branching)
2. [Usage](#usage)
   1. [Setup](#setup)
   2. [Documentation](#documentation)

## Structure

- `README.md`: high-level documentation of this repo
- `Makefile`: scripts to launch common operations in the default way (e.g. generate docs)
- `.gitignore`: files/folders that SHOULD be ignored by Git
- `.tflint.hcl`: TFLint configuration files
- `tfsec.yml`: tfsec configuration files
- `./modules`: contains module sources which are specific to this project
  - at some point some (or all) of them may be moved to their own git repos (depending on their size, usage, update frequency etc)
- `./environment`: contains project infrastructure sources

### Modules

Each module SHOULD:
- be kept in a separate directory named after the module (e.g. ecr-repo)
- define the list of input variables (with sensibe default values) in a `variables.tf` file

### Environment

Environment shall be broken down to layers, each of them representing a logical subset of environment resources. Each layer SHOULD independently define configuration for all needed providers.

Resources that are frequently modified together SHOULD be in the same layer, for example an EC2 instance, and its related IAM Role and policies SHOULD remain in a single layer.

Smaller layers will limit blast radius and make Terraform state refreshes and updates quicker and safer.

Each layer's name SHOULD be prefixed with a 3 digit number, defining the order of dependencies/data flow between layers (from lower to upper). E.g. 000-base SHOULD not reference anything in 100-data or 200-compute, and 100-data SHOULD not reference anything in 200-compute. 

[Terraform data sources](https://developer.hashicorp.com/terraform/language/data-sources) SHOULD be used to access to other layer's state/resources. There MUST be no direct access to another layers.

The following list illustrates which modules/resources SHOULD be instantiated in the suggested layers (treat this as a recommendation and extend/modify per project needs): 
1. 000-base: VPC, Endpoints, Route53 Internal Zone, SSM Service Role, SNS, Peering, VPN, Transit Gateway, Custom IAM, Directory Service
2. 100-data: RDS, DynamoDB, Elasticache, S3, EFS, Elasticsearch
3. 200-compute: EC2, LBs, SQS

### Branching

Each environment shall be kept under a separate branch to facilite PR controlled flow of environment modifications.

## Usage

### Setup

The following prerequisites SHOULD be available on any environment to work with the project. Please refer to the respecvite tools documentation for installation steps.

| Name | Version |
| ---- | ------- |
| [Terraform](https://www.terraform.io/) | 1.3.6 |
| [Lefthook](https://github.com/evilmartians/lefthook) | 1.2.6 |
| [tfsec](https://github.com/aquasecurity/tfsec) | 1.28.1 |
| [TFLint](https://github.com/terraform-linters/tflint) | 0.43.0 |
| [terraform-docs](https://github.com/terraform-docs/terraform-docs) | 0.16.0 |
| [GNU Make](https://www.gnu.org/software/make/) | 3.81 |

> NOTES:
> RECOMMENDED prerequisites installation method on MacOS is `brew install`.
> On a local workstation, Terraform is RECOMMENDED to be installed via `tfenv`

After making sure that all prequisites are available, run the following command in the root directory:

```
$ make setup
```

### Documentation

Generate modules & layers READMEs:
```sh
make docs
```

This MAY fail if there are no `*.tf` files in a module/layer directory.