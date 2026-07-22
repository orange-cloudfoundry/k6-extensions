# Build the k6 binary with the extension
FROM golang:1.26.5@sha256:eb37f58646a901dc7727cf448cae36daaefaba79de33b5058dab79aa4c04aefb as builder

ENV GRAFANA_K6_VERSION="0.56.0"
ENV XK6_MONGO_VERSION="1.2.0"
ENV XK6_SQL_DRIVER_POSTGRES_VERSION="0.1.2"
ENV XK6_SQL_DRIVER_MYSQL_VERSION="0.2.2"
ENV XK6_SQL_VERSION="1.0.6"
ENV XK6_LOKI_VERSION="1.0.1"

# renovate: datasource=github-releases depName=grafana/xk6
ENV XK6_BUILDER_VERSION="1.3.7"


RUN go install go.k6.io/xk6/cmd/xk6@v${XK6_BUILDER_VERSION}
RUN xk6 build --output /k6 \
    --with github.com/GhMartingit/xk6-mongo@v${XK6_MONGO_VERSION} \
    --with github.com/grafana/xk6-sql-driver-postgres@v${XK6_SQL_DRIVER_POSTGRES_VERSION} \
    --with github.com/grafana/xk6-sql-driver-mysql@v${XK6_SQL_DRIVER_MYSQL_VERSION} \
    --with github.com/grafana/xk6-sql@v${XK6_SQL_VERSION} \
    --with github.com/grafana/xk6-loki@v${XK6_LOKI_VERSION}

# Use the operator's base image and override the k6 binary
FROM grafana/k6:1.8.0@sha256:b992f241070f3f3a7d78096fa6020db1edcda49297ee8ed9eb0ab847ef3dcb32
COPY --from=builder /k6 /usr/bin/k6