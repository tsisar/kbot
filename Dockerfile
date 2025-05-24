FROM --platform=$BUILDPLATFORM golang:1.24.3-alpine AS builder

ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache gcc musl-dev

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -ldflags="-s -w" -o /kbot .

FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /root/

COPY --from=builder /kbot .

ENTRYPOINT ["./kbot", "start"]