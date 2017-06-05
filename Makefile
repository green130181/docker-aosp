DOCKER = docker
IMAGE = green369258/aosp:android-n

aosp: Dockerfile
	$(DOCKER) build -t $(IMAGE) .

all: aosp

.PHONY: all
