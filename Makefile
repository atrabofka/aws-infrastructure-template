### Setup
# Should be executed once after the prerequisites defined in the README are installed

.PHONY: setup
setup:
	@lefthook install
	@tflint --init

### Docs
# Should be executed anytime there is a change in modules TF code (to automatically update READMEs)

MODULES = $(shell find ./modules/* -maxdepth 1 -type d)
MODULES_READMES = $(foreach MODULE,$(MODULES),$(MODULE)/README.md)

LAYERS = $(shell find ./environment -name "[0-9]*" -maxdepth 1 -type d)
LAYERS_READMES = $(foreach LAYER,$(LAYERS),$(LAYER)/README.md)

.PHONY: docs
docs: $(MODULES_READMES) $(LAYERS_READMES)
	@echo "All READMEs successfully generated"

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