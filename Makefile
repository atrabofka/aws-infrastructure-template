# ===============================================
# Configurations
# ===============================================

# Your custom Docker image name and tag
IMAGE_NAME = 666156116058.dkr.ecr.us-east-1.amazonaws.com/zealops/terragrunt:aws-0.1.0

# Directory containing Terragrunt configurations
TERRAGRUNT_DIR = terraform/live

# Command to run Terragrunt inside Docker
TERRAGRUNT_RUN = docker run --rm -it \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	$(if $(AWS_SESSION_TOKEN),-e AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN)) \
  -v "$(shell pwd)/terraform/live/$*":/app/live/env \
  -v "$(shell pwd)/terraform/modules":/app/modules \
  -w /app/live/env $(IMAGE_NAME) terragrunt

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
	$(TERRAGRUNT_RUN) init --all

# Target for planning a specific environment
.PHONY: plan-%
plan-%: check-aws-creds
	$(TERRAGRUNT_RUN) plan --all

# Target for applying a specific environment
.PHONY: apply-%
apply-%: check-aws-creds
	$(TERRAGRUNT_RUN) apply --all

# Target for validating a specific environment
.PHONY: validate-%
validate-%: check-aws-creds
	$(TERRAGRUNT_RUN) validate --all

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
