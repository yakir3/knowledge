# main variable
MAINTAINER = yakir
SHELL := /bin/bash
#GIT_COMMIT := $(shell git rev-parse --short HEAD)

# container variable
CONTAINER_CMD := $(shell command -v docker || command -v podman)
ifneq ($(CONTAINER_CMD),)
	CONTAINER_CMD := $(CONTAINER_CMD)
else
	CONTAINER_CMD := ""
endif
CONTAINER_BUILD=$(CONTAINER_CMD) build --rm --force-rm -t
CONTAINER_PRUNE=$(CONTAINER_CMD) image prune --force
CONTAINER_RMI=$(CONTAINER_CMD) rmi ${LOCAL_IMAGE_NAME} && $(CONTAINER_CMD) rmi ${CONTAINERHUB_IMAGE_NAME}
CONTAINER_TAG=$(CONTAINER_CMD) tag
CONTAINER_PUSH=$(CONTAINER_CMD) push

REGISTRY := docker.io/yakirinp/knowledge
VERSION ?= v1
.PHONY: image
image: ## Build a image and push (APP-META/Dockerfile)
	@echo "##### build a image step start #####"
	$(CONTAINER_BUILD) $(REGISTRY):$(VERSION) -f APP-META/Dockerfile .
	$(CONTAINER_PUSH) $(REGISTRY):$(VERSION)
	@echo "##### build a image end #####"

.PHONY: clean
clean:
	@echo "##### clean step start #####"
	@echo "clean image etc.."
	@echo "##### clean step end #####"

.PHONY: test
test: ## Run the tests
	@#$(CURDIR)/test.sh
	@echo "test..."

.PHONY: all
all: precondition test clean ## Build all and push

.PHONY: help
help:
	@grep -E "^[a-zA-Z_-]+:.*?## .*$$" $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS=":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
