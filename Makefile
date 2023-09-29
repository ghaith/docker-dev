TARGET?=$(PWD)
IMAGE_NAME?=docker-dev
all: build run
# Build the image

build: Dockerfile local.toml
	docker build . -t $(IMAGE_NAME) 

run: stop
	docker run --rm -d -it --name $(IMAGE_NAME) -v $(TARGET):/home/dev/work $(IMAGE_NAME)

attach:
	docker exec -it $(IMAGE_NAME) zsh

stop: 
	docker stop $(IMAGE_NAME) || true 
