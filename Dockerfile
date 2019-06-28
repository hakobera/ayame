From golang:1.12 as builder
RUN apt-get update
WORKDIR /go/src/app
COPY Makefile ./
COPY go.mod ./
COPY *.go ./
RUN CGO_ENABLED=0 make linux-build

From alpine:3.10.0
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY --from=builder /go/src/app/ayame-linux /app/ayame
ONBUILD ADD config.yaml ./
ENTRYPOINT ["/app/ayame"]