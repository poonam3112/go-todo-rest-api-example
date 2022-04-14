# # FROM golang:1.17
 
# # RUN mkdir -p /app
 
# # WORKDIR /app
 
# # ADD . /app

# # RUN go mod init github.com/mingrammer/go-todo-rest-api-example

# # RUN go get 

# # RUN go build ./main.go
 
# # CMD ["./app"]

# FROM golang:alpine as builder

# # Enable go modules
# ENV GO111MODULE=on

# # Install git. (alpine image does not have git in it)
# RUN apk update && apk add --no-cache git

# # Set current working directory
# WORKDIR /app

# # Note here: To avoid downloading dependencies every time we
# # build image. Here, we are caching all the dependencies by
# # first copying go.mod and go.sum files and downloading them,
# # to be used every time we build the image if the dependencies
# # are not changed.

# # Copy go mod and sum files
# COPY go.mod ./
# COPY go.sum ./

# # Download all dependencies.
# RUN go mod download

# # Now, copy the source code
# COPY . .

# # Note here: CGO_ENABLED is disabled for cross system compilation
# # It is also a common best practise.

# # Build the application.
# RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./bin/main .

# # Finally our multi-stage to build a small image
# # Start a new stage from scratch
# FROM scratch

# # Copy the Pre-built binary file
# COPY --from=builder /app/bin/main .

# # Run executable
# CMD ["./main"]

FROM golang AS build-env

RUN apt-get update && apt-get install -y ca-certificates openssl



ARG cert_location=/usr/local/share/ca-certificates



# Get certificate from "github.com"
RUN openssl s_client -showcerts -connect github.com:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > ${cert_location}/github.crt
# Get certificate from "proxy.golang.org"
RUN openssl s_client -showcerts -connect proxy.golang.org:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > ${cert_location}/proxy.golang.crt
# Update certificates
RUN update-ca-certificates



# RUN apk --update add git
# RUN go get -u github.com/golang/dep/cmd/dep
ENV GO111MODULE=on


ENV GOOS=linux
ENV GOARCH=386
ENV CGO_ENABLED=0



WORKDIR /app
COPY . .
# RUN dep ensure
# RUN go build main.go
RUN pwd
RUN go build -o go-todo main.go



FROM scratch
COPY --from=build-env /app/ .
ENTRYPOINT ["./go-todo"]