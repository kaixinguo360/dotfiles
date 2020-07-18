main:
	cd ../../.. && \
    docker build . \
		-t myalpine:3 \
        -f data/docker/alpine/Dockerfile \
        --no-cache
	docker image prune -f
	mkdir -p ${HOME}/dc/home/.bin/local
