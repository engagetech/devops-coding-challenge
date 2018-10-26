# Healthchecker

Healthchecker is a small application that makes HTTP GET requests to [Timeapp](../timeapp/README.md) every 2 seconds and prints whether the clock is synchronized or not, and the respective time difference in seconds.

## Build and Run

```
$ go build healthchecker.go
$ ./healthchecker.go http://timeapp.stg.engagetech.capsule.one/now
Clock synchronized. Time diff: 0.431881s
Clock synchronized. Time diff: 0.101007s
Clock desynchronized. Time diff: 1.422374s
Clock synchronized. Time diff: 0.096573s
```

### Docker

```
$ docker build --rm -t hcker .
$ docker run --rm hcker healthchecker http://timeapp.stg.engagetech.capsule.one/now
Clock synchronized. Time diff: 0.431881s
Clock synchronized. Time diff: 0.101007s
Clock desynchronized. Time diff: 1.422374s
Clock synchronized. Time diff: 0.096573s

```
