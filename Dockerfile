# Build the k6 binary with the extension
FROM golang:1.25.0@sha256:e5ab8640ed89da51a95d687efdcef75bf1bf7f66368af2818ff7fd34b0bc6539 as builder

ENV GRAFANA_K6_VERSION="0.56.0"
ENV XK6_MONGO_VERSION="0.2.0"
ENV XK6_SQL_DRIVER_POSTGRES_VERSION="0.1.0"
ENV XK6_SQL_DRIVER_MYSQL_VERSION="0.2.0"
ENV XK6_SQL_VERSION="1.0.5"
ENV XK6_LOKI_VERSION="1.0.1"

# renovate: datasource=github-releases depName=grafana/xk6
ENV XK6_BUILDER_VERSION="0.20.1"


RUN go install go.k6.io/xk6/cmd/xk6@v${XK6_BUILDER_VERSION}
RUN xk6 build --output /k6 \
    --with github.com/GhMartingit/xk6-mongo@v${XK6_MONGO_VERSION} \
    --with github.com/grafana/xk6-sql-driver-postgres@v${XK6_SQL_DRIVER_POSTGRES_VERSION} \
    --with github.com/grafana/xk6-sql-driver-mysql@v${XK6_SQL_DRIVER_MYSQL_VERSION} \
    --with github.com/grafana/xk6-sql@v${XK6_SQL_VERSION} \
    --with github.com/grafana/xk6-loki@v${XK6_LOKI_VERSION}

# Use the operator's base image and override the k6 binary
FROM grafana/k6:1.2.3@sha256:4f82892217f3110cb233e2b2622bcc97fabc70f14bd241fbfbfe7305105c68aa
COPY --from=builder /k6 /usr/bin/k6