FROM golang:1.11.1-alpine3.8

COPY ./healthchecker.go $GOPATH/src/healthchecker/healthchecker.go

RUN go install healthchecker

