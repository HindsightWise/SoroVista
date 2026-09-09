FROM golang:1.25-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /out/sorovista ./cmd/sorovista

FROM alpine:3.20
RUN adduser -D -H sorovista && apk add --no-cache ca-certificates
USER sorovista
COPY --from=build /out/sorovista /usr/local/bin/sorovista
EXPOSE 8080
ENTRYPOINT ["sorovista"]
