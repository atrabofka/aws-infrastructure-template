### Common variables used in most of the specific tasks

MODULES = $(shell find ./modules/* -maxdepth 1 -type d)
LAYERS = $(shell find ./environment -name "[0-9]*" -maxdepth 1 -type d)
LAYERS_TERRAFORM_DIRS = $(foreach LAYER,$(LAYERS),$(LAYER)/.terraform)

### Setup
# SHOULD be executed when the project is cloned for the 1st time.
# All the prerequisites defined in the README MUST installed before.

.PHONY: setup
setup:
	@lefthook install
	@tflint --init

### Init
# SHOULD be executed for `terraform init` in all environment layers

.PHONY: init
# init:
init: $(LAYERS_TERRAFORM_DIRS)
	@echo "All environment layers are initalized!"

./environment/%/.terraform: ./environment/%/*.tf
	@echo "Initializing $(dir $@)"
	@cd $(dir $@); terraform init

### Docs
# SHOULD be executed to update modules & environment layers READMEs

MODULES_READMES = $(foreach MODULE,$(MODULES),$(MODULE)/README.md)
LAYERS_READMES = $(foreach LAYER,$(LAYERS),$(LAYER)/README.md)

.PHONY: docs
docs: $(MODULES_READMES) $(LAYERS_READMES)
	@echo "All READMEs are up-to-date!"

./modules/%/README.md : ./modules/%/*.tf
	@echo "Generating $@"
	@terraform-docs markdown $(subst /README.md,,$@) \
		--output-file README.md \
		--output-mode replace

./environment/%/README.md : ./environment/%/*.tf
	@echo "Generating $@"
	@terraform-docs markdown $(subst /README.md,,$@) \
		--output-file README.md \
		--output-mode replace

### TFlint
# SHOULD be executed to validate TF code via TFLint

# Files indicating last successful TFlint execution in the layer
LAYERS_TFLINT_OKS = $(foreach LAYER,$(LAYERS),$(LAYER)/.tflint.ok)

.PHONY: tflint
tflint: $(LAYERS_TFLINT_OKS)
	@echo "All environment layers TFlint checks are up-to-date!"

./environment/%/.tflint.ok: ./environment/%/*.tf
	@echo "Running TFlint on $(dir $@)" 
	@tflint --chdir=$(dir $@) --module
	@touch $@
