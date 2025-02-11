# Build the k6 binary with the extension
FROM golang:1.23.4 as builder

RUN go install go.k6.io/xk6/cmd/xk6@latest
RUN xk6 build --output /k6 --with github.com/GhMartingit/xk6-mongo --with github.com/grafana/xk6-sql-driver-postgres --with github.com/grafana/xk6-sql --with github.com/grafana/xk6-loki

# Use the operator's base image and override the k6 binary
FROM loadimpact/k6:latest
COPY --from=builder /k6 /usr/bin/k6