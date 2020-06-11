# singularity-test-containers

Dockerfiles & Definition files used for containers pulled from the Singularity
test suite.

## docker-*

Currently these live at hub.docker.com/u/sylabsio

To build and push these containers for multiple architectures, using Docker
Desktop, ensure you are using Docker Desktop >2.0.4.0 and turn on Command Line
Experimental Features in preferences.

Setup a buildx multi-arch builder:

```
docker buildx create --name archbuilder
docker buildx use archbuilder
docker buildx inspect --bootstrap
```

Build and push the containers using the provided script:

```
./build_push_docker.sh
```



