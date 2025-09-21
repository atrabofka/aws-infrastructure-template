# ===============================================
# Configurations
# ===============================================

# Your custom Docker image name and tag
IMAGE_NAME = 666156116058.dkr.ecr.us-east-1.amazonaws.com/zealous/terragrunt:aws-0.1.0

# Directory containing Terragrunt configurations
TERRAGRUNT_DIR = terraform/live

# Detect if running in CI
# GitHub Actions automatically sets CI=true
ifeq ($(CI),true)
    DOCKER_TTY=
else
    DOCKER_TTY=-t
endif

# List of live environments
ENVS := qa prod

# Command to run Dockerized Terragrunt with AWS credentials and volume mounts for live envs
DOCKER_RUN_LIVE = docker run --rm -i $(DOCKER_TTY) \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	$(if $(AWS_SESSION_TOKEN),-e AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN)) \
	-v "$(shell pwd)/terraform/live/$*":/app/live/env \
	-v "$(shell pwd)/terraform/modules":/app/modules \
	-w /app/live/env $(IMAGE_NAME)

# Command to run Dockerized Terragrunt with AWS credentials and volume mounts for modules
DOCKER_RUN_MODULES = docker run --rm -i $(DOCKER_TTY) \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	$(if $(AWS_SESSION_TOKEN),-e AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN)) \
	-v "$(shell pwd)/terraform/modules":/app/modules \
	-w /app/modules $(IMAGE_NAME)

##===============================================
# Default Target
# ===============================================

# Print all commands
.PHONY: all
all:
	@echo "Lifecycle Commands:"
	@echo "  init-<env>           Initialize Terragrunt for an environment (e.g., make init-qa)"
	@echo "  plan-<env>           Run terragrunt plan for an environment"
	@echo "  apply-<env>          Run terragrunt apply for an environment"
	@echo "  validate-<env>       Run terragrunt validate for an environment"
	@echo ""
	@echo "Helper Commands:"
	@echo "  clean-<env>          Clean .terragrunt-cache and .terraform for an environment"
	@echo "  fmt-modules          Format all Terraform files in modules"
	@echo "  fmt-<env>            Format all terragrunt.hcl files in an environment"
	@echo "  fmt                  Format all Terraform modules and Terragrunt live environments"
	@echo "  fmt-check-<env>      Check formatting of all terragrunt.hcl files in an environment"
	@echo "  fmt-check-modules    Check formatting of all Terraform files in modules"
	@echo "  fmt-check            Check formatting of all Terraform modules and Terragrunt live environments"
	@echo "  check-aws-creds      Check AWS credentials"

# ===============================================
# Lifecycle Commands
# ===============================================

# A helper target to check for AWS credentials
.PHONY: check-aws-creds
check-aws-creds:
	@if [ -z "$$AWS_ACCESS_KEY_ID" ] || [ -z "$$AWS_SECRET_ACCESS_KEY" ]; then \
		echo "Error: AWS_ACCESS_KEY_ID and/or AWS_SECRET_ACCESS_KEY are not set."; \
		exit 1; \
	fi
	@echo "AWS credentials found. Proceeding with command..."

# Target for initializing a specific environment
.PHONY: init-%
init-%: check-aws-creds
	$(DOCKER_RUN_LIVE) terragrunt init --all

# Target for planning a specific environment
.PHONY: plan-%
plan-%: check-aws-creds
	$(DOCKER_RUN_LIVE) terragrunt plan --all

# Target for applying a specific environment
.PHONY: apply-%
apply-%: check-aws-creds
	$(DOCKER_RUN_LIVE) terragrunt apply --all

# Target for validating a specific environment
.PHONY: validate-%
validate-%: check-aws-creds
	$(DOCKER_RUN_LIVE) terragrunt validate --all

# ===============================================
# Helper Commands
# ===============================================

# Target for cleaning a specific environment
.PHONY: clean-%
clean-%:
	@echo "Cleaning Terragrunt cache and Terraform files for env: $*"
	find $(TERRAGRUNT_DIR)/$* -type d -name ".terragrunt-cache" -print0 | xargs -0 rm -rf
	find $(TERRAGRUNT_DIR)/$* -type d -name ".terraform" -print0 | xargs -0 rm -rf
	find $(TERRAGRUNT_DIR)/$* -type f -name ".terraform.lock.hcl" -delete
	@echo "Cleanup for env '$*' complete."

# Target for checking formatting of all Terragrunt files in a specific live environment
.PHONY: fmt-check-%
fmt-check-%:
	$(DOCKER_RUN_LIVE) sh -c 'find . -name terragrunt.hcl -exec terragrunt hcl format --check {} \;'

# Target for formatting all Terragrunt files in a specific live environment
.PHONY: fmt-%
fmt-%:
	$(DOCKER_RUN_LIVE) sh -c 'find . -name terragrunt.hcl -exec terragrunt hcl format {} \;'

# Target for checking formatting of all Terraform files in modules
.PHONY: fmt-check-modules
fmt-check-modules:
	$(DOCKER_RUN_MODULES) terraform fmt -recursive --check

# Target for formatting all Terraform files in modules
.PHONY: fmt-modules
fmt-modules:
	$(DOCKER_RUN_MODULES) terraform fmt -recursive

# Target for checking formatting of all Terraform modules and Terragrunt live environments
.PHONY: fmt-check
fmt-check: fmt-check-modules $(ENVS:%=fmt-check-%)

# Target for formatting all Terraform modules and Terragrunt live environments
.PHONY: fmt
fmt: fmt-modules $(ENVS:%=fmt-%)
