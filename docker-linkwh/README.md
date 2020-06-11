# docker-singularity-userperms

This is a test container for Singularity issue #1592 #1576.

See `e2e/docker/docker.go`

The image should build cleanly. If it does not, then whiteout of symbolic links
is not working correctly.
