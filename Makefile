TARGET?=$(PWD)
IMAGE_NAME?=docker-dev
USER?=dev
UID?=1000
GID?=100

all: build run
# Build the image

build: Dockerfile local.toml
	echo $(USER_ID)
	podman build -t $(IMAGE_NAME) \
		--build-arg USER=$(USER)  \
		--build-arg UID=$(UID)  \
		--build-arg GID=$(GID)  \
		--no-cache \
		.  

run: stop
	podman run \
		--userns keep-id \
		--rm -d -it \
		--name $(IMAGE_NAME) \
		-v $(TARGET):/home/$(USER)/work \
		$(IMAGE_NAME)

attach:
	podman exec -it $(IMAGE_NAME) zsh

stop: 
	podman stop $(IMAGE_NAME) || true 
