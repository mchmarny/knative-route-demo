
# Go parameters
BINARY_NAME=elafros-route-demo
GCP_PROJECT_NAME=elafros-samples

all: test

deps:
	go get github.com/tools/godep
	godep restore

build:
	go build -v -o ./bin/$(BINARY_NAME)

push:
	gcloud container builds submit --project=$(GCP_PROJECT_NAME) --tag gcr.io/$(GCP_PROJECT_NAME)/$(BINARY_NAME):latest .

test:
	go test -v ./...

clean:
	go clean
	rm -f ./bin/$(BINARY_NAME)

run: build
	open http://127.0.0.1:8080
	bin/$(BINARY_NAME)
