TARGET?=$(PWD)
IMAGE_NAME?=docker-dev
USER?=dev
UID?=1000
GID?=100

all: build run
# Build the image

build: Dockerfile local.toml
	echo $(USER_ID)
	docker build -t $(IMAGE_NAME) \
		--build-arg USER=$(USER)  \
		--build-arg UID=$(UID)  \
		--build-arg GID=$(GID)  \
		.  

run: stop
	docker run \
		--rm -d -it \
		--name $(IMAGE_NAME) \
		-v $(TARGET):/home/$(USER)/work \
		$(IMAGE_NAME)

attach:
	docker exec -it $(IMAGE_NAME) zsh

stop: 
	docker stop $(IMAGE_NAME) || true 
