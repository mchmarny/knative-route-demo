FROM golang:1.9.2 as builder

WORKDIR /go/src/github.com/mchmarny/elafros-route-demo/
COPY . .

# restore to pinnned versions of dependancies 
RUN go get -u github.com/tools/godep
RUN godep restore

# build
RUN CGO_ENABLED=0 GOOS=linux go build -a -o elafros-route-demo \
    -tags netgo -installsuffix netgo .

# build the clean image
FROM scratch as runner
# copy the app
COPY --from=builder /go/src/github.com/mchmarny/elafros-route-demo/elafros-route-demo .
# copy static artifacts 
COPY --from=builder /go/src/github.com/mchmarny/elafros-route-demo/static /static
COPY --from=builder /go/src/github.com/mchmarny/elafros-route-demo/templates /templates

ENTRYPOINT ["/elafros-route-demo"]
