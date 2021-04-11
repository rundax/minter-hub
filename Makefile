	include .env
	export

.PHONY: build
build: ## build environment and initialize composer and project dependencies
	docker build .docker/base/ \
		--tag $(DOCKER_SERVER_HOST):$(DOCKER_SERVER_PORT)/$(DOCKER_PROJECT_PATH)/base:$(DOCKER_IMAGE_VERSION) \
		--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
		--build-arg DOCKER_SERVER_PORT=$(DOCKER_SERVER_PORT) \
		--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
		--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION) \
		--build-arg MINTER_HUB_TAG=$(MINTER_HUB_TAG)

#	docker build .docker/mhub/ \
#		--tag $(DOCKER_SERVER_HOST):$(DOCKER_SERVER_PORT)/$(DOCKER_PROJECT_PATH)/mhub:$(DOCKER_IMAGE_VERSION) \
#		--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
#		--build-arg DOCKER_SERVER_PORT=$(DOCKER_SERVER_PORT) \
#		--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
#		--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)

up:
	docker-compose up -d

stop:
	docker-compose stop

logs:
	docker-compose logs -f