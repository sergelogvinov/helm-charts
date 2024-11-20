#

PACKAGES = $(patsubst charts/%/,%,$(dir $(wildcard charts/*/Chart.yaml)))

################################################################################

define HELP_MENU_HEADER
# Getting Started

To build and check this project, you must have the following installed:

- git
- make
- helm
- helm-docs
- chart-testing
- yamllint

endef

export HELP_MENU_HEADER

################################################################################

help:
	@echo "$$HELP_MENU_HEADER"
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

list: ## List all helm charts
	@echo -n $(PACKAGES)

lint: ## Lint helm chart
	@ct lint --config .github/ct.yml --lint-conf .github/lintconf.yaml

test: $(foreach pkg,$(PACKAGES),test-$(pkg)) ## Test helm chart
test-%:
	@echo Test $*
	@helm template -f charts/$*/ci/values.yaml test charts/$* | kubeconform -summary -schema-location default -schema-location 'https://raw.githubusercontent.com/sergelogvinov/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json'

docs: $(foreach pkg,$(PACKAGES),docs-$(pkg)) ## Update helm chart readme
docs-%:
	@echo Update $* README.md
	@cd charts/$*; helm-docs --sort-values-order=file
