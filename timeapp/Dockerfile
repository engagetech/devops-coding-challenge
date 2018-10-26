FROM golang:1.11.1-alpine3.8

COPY ./timeapp.go $GOPATH/src/timeapp/timeapp.go

RUN go install timeapp

EXPOSE 8080

CMD $GOPATH/bin/timeapp
