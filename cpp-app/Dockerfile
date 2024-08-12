FROM gcc:10.3 as builder

WORKDIR /app
COPY main.cpp .

RUN g++ -o cpp_app main.cpp

FROM alpine:latest

COPY --from=builder /app/cpp_app /usr/local/bin/cpp_app

CMD ["cpp_app"]

