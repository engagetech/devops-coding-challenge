# Timeapp

Timeapp is a small application that serves HTTP requests on the endpoint `/now` and returns the current time.

## Build and Run

```
$ go build timeapp.go
$ ./timeapp
```

### Docker

```
$ docker build --rm -t timeapp .
$ docker run -d -p 80:8080 timeapp
```

### Docker-compose

```
$ docker-compose build
$ docker-compose up -d
```

## Usage

```
$ curl localhost/now
2018-10-25 19:40:46.926302223 +0000 UTC
```