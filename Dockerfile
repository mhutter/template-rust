### BUILD ######################################################################
FROM docker.io/library/rust:1.82-alpine AS build
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache mold musl-dev

COPY . .
RUN --mount=type=cache,target=/root/.rustup \
    --mount=type=cache,target=/root/.cargo/registry \
    --mount=type=cache,target=/root/.cargo/git \
    --mount=type=cache,target=/app/target \
    set -eux; \
    cargo build --release --locked; \
    cp target/release/{{project-name}} .

### RUNTIME ####################################################################
FROM docker.io/library/alpine:latest
ENV LISTEN_ADDR=0.0.0.0:3000
EXPOSE 3000

COPY --from=build /app/{{project-name}} /usr/local/bin/{{project-name}}
CMD ["/usr/local/bin/{{project-name}}"]
