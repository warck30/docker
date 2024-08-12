FROM alpine:latest

COPY --from=cpp-app /usr/local/bin/cpp_app /usr/local/bin/cpp_app

COPY --from=go-app /usr/local/bin/go_app /usr/local/bin/go_app

ENTRYPOINT []