# Build the k6 binary with the extension
FROM golang:1.23.4 as builder

RUN go install go.k6.io/xk6/cmd/xk6@latest
RUN xk6 build --output /k6 --with github.com/GhMartingit/xk6-mongo@v0.1.3 --with github.com/grafana/xk6-sql-driver-postgres@v0.1.0 --with github.com/grafana/xk6-sql-driver-mysql@v0.1.0 --with github.com/grafana/xk6-sql@v1.0.1 --with github.com/grafana/xk6-loki@v1.0.0

# Use the operator's base image and override the k6 binary
FROM grafana/k6:0.56.0
COPY --from=builder /k6 /usr/bin/k6