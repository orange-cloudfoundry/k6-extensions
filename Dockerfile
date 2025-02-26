# Build the k6 binary with the extension
FROM golang:1.24.0@sha256:cd0c949a4709ef70a8dad14274f09bd07b25542de5a1c4812f217087737efd17 as builder

ENV GRAFANA_K6_VERSION="0.56.0"
ENV XK6_MONGO_VERSION="0.1.3"
ENV XK6_SQL_DRIVER_POSTGRES_VERSION="0.1.0"
ENV XK6_SQL_DRIVER_MYSQL_VERSION="0.1.0"
ENV XK6_SQL_VERSION="1.0.1"
ENV XK6_LOKI_VERSION="1.0.0"

# renovate: datasource=github-releases depName=grafana/xk6
ENV XK6_BUILDER_VERSION="0.14.2"


RUN go install go.k6.io/xk6/cmd/xk6@v${XK6_BUILDER_VERSION}
RUN xk6 build --output /k6 \
    --with github.com/GhMartingit/xk6-mongo@v${XK6_MONGO_VERSION} \
    --with github.com/grafana/xk6-sql-driver-postgres@v${XK6_SQL_DRIVER_POSTGRES_VERSION} \
    --with github.com/grafana/xk6-sql-driver-mysql@v${XK6_SQL_DRIVER_MYSQL_VERSION} \
    --with github.com/grafana/xk6-sql@v${XK6_SQL_VERSION} \
    --with github.com/grafana/xk6-loki@v${XK6_LOKI_VERSION}

# Use the operator's base image and override the k6 binary
FROM grafana/k6:0.56.0
COPY --from=builder /k6 /usr/bin/k6