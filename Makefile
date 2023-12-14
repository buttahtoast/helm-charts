# Helm
SRC_ROOT = $(shell git rev-parse --show-toplevel)

helm-docs: HELMDOCS_VERSION := v1.11.0
helm-docs: docker
	@docker run -v "$(SRC_ROOT):/helm-docs" jnorwood/helm-docs:$(HELMDOCS_VERSION) --chart-search-root /helm-docs

helm-init:
	helm repo add buttahtoast https://buttahtoast.github.io/helm-charts

helm-lint: ct helm-init
	@$(CT) lint --config ./.github/configs/ct.yaml --lint-conf ./.github/configs/lintconf.yaml --all --debug

helm-test: kind
	@$(KIND) create cluster --wait=60s --name buttah-charts
	@make helm-install
	@$(KIND) delete cluster --name buttah-charts

helm-install: ct helm-init
	@kubectl apply --server-side=true -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
	@kubectl apply --server-side=true -f https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.58.0/bundle.yaml
	@$(CT) install --config $(SRC_ROOT)/.github/configs/ct.yaml --all --debug

helm-destroy: kind
	@$(KIND) delete cluster --name buttah-charts

CT         := $(shell pwd)/bin/ct
CT_VERSION := v3.7.1
ct: ## Download ct locally if necessary.
	$(call go-install-tool,$(CT),github.com/helm/chart-testing/v3/ct@$(CT_VERSION))

KIND         := $(shell pwd)/bin/kind
KIND_VERSION := v0.17.0
kind: ## Download kind locally if necessary.
	$(call go-install-tool,$(KIND),sigs.k8s.io/kind/cmd/kind@$(KIND_VERSION))

# go-install-tool will 'go install' any package $2 and install it to $1.
PROJECT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
define go-install-tool
@[ -f $(1) ] || { \
set -e ;\
GOBIN=$(PROJECT_DIR)/bin go install $(2) ;\
}
endef

docker:
	@hash docker 2>/dev/null || {\
		echo "You need docker" &&\
		exit 1;\
	}