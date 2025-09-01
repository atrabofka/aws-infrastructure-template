# Your custom Docker image name and tag
IMAGE_NAME = 666156116058.dkr.ecr.us-east-1.amazonaws.com/zealops/terragrunt:aws-0.1.0

# Base command for running Docker
DOCKER_RUN = docker run --rm -it \
  -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
#   -e AWS_SESSION_TOKEN

# Default profile (can be overridden: make export-aws-creds PROFILE=dev)
PROFILE ?= default

# The commands to run
.PHONY: export-aws-creds
export-aws-creds:
# 	@echo "Exporting AWS credentials from profile: $(PROFILE)"
	@aws configure export-credentials --profile $(PROFILE) --format env | xargs
# 	@echo "Credentials loaded into current shell. To verify, check AWS_ACCESS_KEY_ID variable." 

.PHONY: plan-%
plan-%:
	$(DOCKER_RUN) \
		-v "$(shell pwd)/terraform/live/$*":/app/live/env \
		-v "$(shell pwd)/terraform/modules":/app/modules \
		-w /app/live/env $(IMAGE_NAME) terragrunt plan --all

.PHONY: apply-%
apply-%:
	$(DOCKER_RUN) \
		-v "$(shell pwd)/terraform/live/$*":/app/live/env \
		-v "$(shell pwd)/terraform/modules":/app/modules \
		-w /app/live/env $(IMAGE_NAME) terragrunt apply --all

.PHONY: validate-%
validate-%:
	$(DOCKER_RUN) \
		-v "$(shell pwd)/terraform/live/$*":/app/live/env \
		-v "$(shell pwd)/terraform/modules":/app/modules \
		-w /app/live/env $(IMAGE_NAME) terragrunt validate --all
