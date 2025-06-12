# Build the k6 binary with the extension
FROM golang:1.24.4@sha256:10c131810f80a4802c49cab0961bbe18a16f4bb2fb99ef16deaa23e4246fc817 as builder

ENV GRAFANA_K6_VERSION="0.56.0"
ENV XK6_MONGO_VERSION="0.2.0"
ENV XK6_SQL_DRIVER_POSTGRES_VERSION="0.1.0"
ENV XK6_SQL_DRIVER_MYSQL_VERSION="0.1.0"
ENV XK6_SQL_VERSION="1.0.4"
ENV XK6_LOKI_VERSION="1.0.1"

# renovate: datasource=github-releases depName=grafana/xk6
ENV XK6_BUILDER_VERSION="0.19.1"


RUN go install go.k6.io/xk6/cmd/xk6@v${XK6_BUILDER_VERSION}
RUN xk6 build --output /k6 \
    --with github.com/GhMartingit/xk6-mongo@v${XK6_MONGO_VERSION} \
    --with github.com/grafana/xk6-sql-driver-postgres@v${XK6_SQL_DRIVER_POSTGRES_VERSION} \
    --with github.com/grafana/xk6-sql-driver-mysql@v${XK6_SQL_DRIVER_MYSQL_VERSION} \
    --with github.com/grafana/xk6-sql@v${XK6_SQL_VERSION} \
    --with github.com/grafana/xk6-loki@v${XK6_LOKI_VERSION}

# Use the operator's base image and override the k6 binary
FROM grafana/k6:1.0.0@sha256:f21270290d702cbf0a7d6ba5d7ed100b63bcb233b558b885ed787547b3488279
COPY --from=builder /k6 /usr/bin/k6