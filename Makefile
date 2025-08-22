# Your custom Docker image name and tag
IMAGE_NAME = 666156116058.dkr.ecr.us-east-1.amazonaws.com/zealops/terragrunt:aws-0.1.0

# Base command for running Docker
DOCKER_RUN = docker run --rm -it

# The commands to run
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
