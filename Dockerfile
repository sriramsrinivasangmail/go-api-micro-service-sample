
## this is the container where the golang executable gets builtA

FROM golang:1.10.3-alpine

RUN apk add curl git xz upx && mkdir tools && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && curl -o /usr/local/bin/swagger -L'#' https://github.com/go-swagger/go-swagger/releases/download/0.16.0/swagger_$(echo `uname`|tr '[:upper:]' '[:lower:]')_amd64 && chmod +x /usr/local/bin/swagger

COPY / /go/src/example-api
WORKDIR /go/src/example-api

RUN ./build_binary.sh 


## this is the container where it gets shipped from - note only scratch and with just the binary
FROM scratch
ENV GOPATH /go/src
COPY --from=0 /go/src/example-api/bin/example-server /example-server
EXPOSE 3333
ENTRYPOINT [ "/example-server", "--host", "0.0.0.0", "--port", "3333" ]
