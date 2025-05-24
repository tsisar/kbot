REGISTRY := ghcr.io/tsisar
APP := kbot
VERSION := $(shell git rev-parse --short HEAD)
IMAGE := $(REGISTRY)/$(APP):$(VERSION)

PLATFORMS := linux/amd64,linux/arm64

.PHONY: all linux linux-arm64 darwin darwin-arm64 windows image test clean

all: linux linux-arm64 darwin darwin-arm64 windows

linux:
	mkdir -p build
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o build/$(APP)-linux-amd64 .

linux-arm64:
	mkdir -p build
	GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o build/$(APP)-linux-arm64 .

darwin:
	mkdir -p build
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -o build/$(APP)-darwin-amd64 .

darwin-arm64:
	mkdir -p build
	GOOS=darwin GOARCH=arm64 CGO_ENABLED=0 go build -o build/$(APP)-darwin-arm64 .

windows:
	mkdir -p build
	GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -o build/$(APP)-windows-amd64.exe .

image:
	docker buildx build \
		--platform=$(PLATFORMS) \
		--tag=$(IMAGE) \
		--push \
		.

test:
	docker run --rm $(IMAGE)

clean:
	rm -rf build
	docker rmi $(IMAGE) || true