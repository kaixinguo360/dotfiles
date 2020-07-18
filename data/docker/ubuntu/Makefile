main:
	cd ../../.. && \
    docker build . \
		-t myubuntu:16.04 \
        -f data/docker/ubuntu/Dockerfile \
        --no-cache
	docker image prune -f
	mkdir -p ${HOME}/dc/home/.bin/local
