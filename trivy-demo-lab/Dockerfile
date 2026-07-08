# Build stage
FROM golang:1.22-alpine3.19 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o trivy ./cmd/trivy

# Final stage
FROM alpine:3.19
RUN apk --no-cache add ca-certificates git
WORKDIR /
COPY --from=builder /app/trivy /usr/local/bin/trivy
ENTRYPOINT ["trivy"]
CMD ["--help"]
