REGISTRY := ghcr.io/tsisar
APP := kbot
VERSION := $(shell git rev-parse --short HEAD)
IMAGE := $(REGISTRY)/$(APP):$(VERSION)

PLATFORMS := linux/amd64 linux/arm64 darwin/amd64 windows/amd64

.PHONY: all linux arm darwin windows image clean

all: linux arm darwin windows

linux:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bin/$(APP)-linux-amd64 .

arm:
	GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o bin/$(APP)-linux-arm64 .

darwin:
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -o bin/$(APP)-darwin-arm64 .

windows:
	GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o bin/$(APP)-windows-amd64.exe .

image:
	docker buildx create --use --name $(APP)-builder || true
	docker buildx inspect $(APP)-builder --bootstrap
	docker buildx build \
		--platform=linux/amd64,linux/arm64 \
		--tag $(IMAGE) \
		--push \
		.

clean:
	rm -rf build
	docker rmi $(IMAGE) || true