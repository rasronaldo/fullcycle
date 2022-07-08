FROM golang:latest AS builder

WORKDIR /usr/src/app

COPY go.mod ./
RUN go mod download && go mod verify

COPY . .
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux go build  -ldflags="-s -w" -o /usr/local/bin/app .

FROM scratch
WORKDIR /root
COPY --from=builder /usr/local/bin/app /root
ENTRYPOINT [ "/root/app" ]
