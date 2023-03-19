#

PACKAGES = $(patsubst charts/%/,%,$(dir $(wildcard charts/*/Chart.yaml)))

################################################################################

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

list: ## List all helm charts
	@echo -n $(PACKAGES)

test: $(foreach pkg,$(PACKAGES),test-$(pkg)) ## Test helm chart
test-%:
	@echo Test $*
	@helm template test charts/$* | kubeconform -summary -schema-location default -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json'
