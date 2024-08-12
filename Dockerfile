FROM alpine:latest

COPY --from=cpp-app /usr/local/bin/cpp_app /usr/local/bin/cpp_app

COPY --from=go-app /usr/local/bin/go_app /usr/local/bin/go_app

CMD ["sh", "-c", "echo 'Specify the app to run: cpp_app or go_app' && exec \"$0\" \"$@\""]
ENTRYPOINT ["/usr/local/bin/cpp_app"]

