DOCKER = docker
IMAGE = green369258/aosp:android-m

aosp: Dockerfile
	$(DOCKER) build -t $(IMAGE) .

all: aosp

.PHONY: all
