# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM quay.io/projectquay/golang:1.21 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go test -v ./... -cover -short > /test-result.txt && \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -o /app/build-output .

FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /root/

COPY --from=builder /app/build-output ./app
COPY --from=builder /test-result.txt .

ENTRYPOINT ["./app"]