FROM golang:1.18 as builder

WORKDIR /app
COPY main.go .

RUN go build -o go_app main.go

FROM alpine:latest

COPY --from=builder /app/go_app /usr/local/bin/go_app

CMD ["go_app"]

