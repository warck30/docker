FROM gcc:10.3 AS builder_cpp

WORKDIR /src

COPY cpp-app/main.cpp .

RUN g++ -o cpp_app main.cpp -static

FROM golang:1.18 AS builder_go

WORKDIR /src

COPY go-app/main.go .

RUN go build -o go_app main.go

FROM alpine:3.20

WORKDIR /app

COPY --from=builder_cpp /src/cpp_app /app/

COPY --from=builder_go /src/go_app /app/

ENTRYPOINT ["sh", "-c"]

CMD ["echo 'Выберите приложение: cpp или go' && read APP && if [ \"$APP\" = \"cpp\" ]; then exec /app/cpp_app; elif [ \"$APP\" = \"go\" ]; then exec /app/go_app; else echo 'Неверный выбор'; fi"]