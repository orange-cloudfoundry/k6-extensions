# Build the k6 binary with the extension
FROM golang:1.24.2@sha256:991aa6a6e4431f2f01e869a812934bd60fbc87fb939e4a1ea54b8494ab9d2fc6 as builder

ENV GRAFANA_K6_VERSION="0.56.0"
ENV XK6_MONGO_VERSION="0.1.3"
ENV XK6_SQL_DRIVER_POSTGRES_VERSION="0.1.0"
ENV XK6_SQL_DRIVER_MYSQL_VERSION="0.1.0"
ENV XK6_SQL_VERSION="1.0.4"
ENV XK6_LOKI_VERSION="1.0.0"

# renovate: datasource=github-releases depName=grafana/xk6
ENV XK6_BUILDER_VERSION="0.14.3"


RUN go install go.k6.io/xk6/cmd/xk6@v${XK6_BUILDER_VERSION}
RUN xk6 build --output /k6 \
    --with github.com/GhMartingit/xk6-mongo@v${XK6_MONGO_VERSION} \
    --with github.com/grafana/xk6-sql-driver-postgres@v${XK6_SQL_DRIVER_POSTGRES_VERSION} \
    --with github.com/grafana/xk6-sql-driver-mysql@v${XK6_SQL_DRIVER_MYSQL_VERSION} \
    --with github.com/grafana/xk6-sql@v${XK6_SQL_VERSION} \
    --with github.com/grafana/xk6-loki@v${XK6_LOKI_VERSION}

# Use the operator's base image and override the k6 binary
FROM grafana/k6:0.58.0@sha256:6a4eabc37ea8274aff48804ff1add146b4eda476fdf50ea6e9cdf083a3967616
COPY --from=builder /k6 /usr/bin/k6