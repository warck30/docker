# Этап 1: Сборка C/C++ приложения
FROM gcc:10.3 AS builder_cpp

WORKDIR /src

COPY main.cpp .

RUN g++ -o cpp_app main.cpp -static

# Этап 2: Сборка Go приложения
FROM golang:1.18 AS builder_go

WORKDIR /src

COPY main.go .

RUN go build -o go_app main.go

# Этап 3: Объединение собранных приложений в один образ
FROM alpine:3.20

WORKDIR /app

# Исправлено: указаны правильные теги для копирования файлов из предыдущих этапов
COPY --from=builder_cpp /src/cpp_app /app/
COPY --from=builder_go /src/go_app /app/

# Определение точек входа для каждого приложения
ENTRYPOINT ["sh", "-c"]
CMD ["echo 'Выберите приложение: cpp или go' && read APP && if [ \"$APP\" = \"cpp\" ]; then exec /app/cpp_app; elif [ \"$APP\" = \"go\" ]; then exec /app/go_app; else echo 'Неверный выбор'; fi"]
