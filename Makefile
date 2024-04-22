### Common variables used in most of the specific tasks

MODULES = $(shell find ./modules/* -maxdepth 1 -type d)
LAYERS = $(shell find ./environment -name "[0-9]*" -maxdepth 1 -type d)
LAYERS_TERRAFORM_DIRS = $(foreach LAYER,$(LAYERS),$(LAYER)/.terraform)

### setup
# SHOULD be executed when the project is cloned for the 1st time.
# All the prerequisites defined in the README MUST installed before.

.PHONY: setup
setup:
	@lefthook install
	@tflint --init

### init
# SHOULD be executed for `terraform init` in all environment layers

.PHONY: init
# init:
init: $(LAYERS_TERRAFORM_DIRS)
	@echo "All environment layers are initalized!"

./environment/%/.terraform: ./environment/%/*.tf
	@echo "Initializing $(dir $@)"
	@cd $(dir $@); terraform init

### docs
# SHOULD be executed to update modules & environment layers READMEs

MODULES_READMES = $(foreach MODULE,$(MODULES),$(MODULE)/README.md)
LAYERS_READMES = $(foreach LAYER,$(LAYERS),$(LAYER)/README.md)
PUMLS = $(shell find . -name '*.puml' -type f)
PNGS = $(patsubst %.puml,%.png,$(PUMLS))

.PHONY: docs
docs: $(MODULES_READMES) $(LAYERS_READMES) $(PNGS)
	@echo "All READMEs are up-to-date!"

./modules/%/README.md : ./modules/%/*.tf
	@echo "Running terraform-docs on $(dir $@)"
	@terraform-docs markdown $(subst /README.md,,$@) \
		--output-file README.md \
		--output-mode replace

./environment/%/README.md : ./environment/%/*.tf
	@echo "Running terraform-docs on $(dir $@)"
	@terraform-docs markdown $(subst /README.md,,$@) \
		--output-file README.md \
		--output-mode replace

%.png: %.puml
	@plantuml $<

### tflint
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

### tfsec
# SHOULD be executed to validate TF code via tfsec

# Files indicating last successful TFlint execution in the layer
LAYERS_TFSEC_OKS = $(foreach LAYER,$(LAYERS),$(LAYER)/.tfsec.ok)

.PHONY: tfsec
tfsec: $(LAYERS_TFSEC_OKS)
	@echo "All environment layers tfsec checks are up-to-date!"

./environment/%/.tfsec.ok: ./environment/%/*.tf
	@echo "Running tfsec on $(dir $@)" 
	@tfsec --config-file tfsec.yml --tfvars-file $(dir $@)/terraform.tfvars $(dir $@)
	@touch $@
