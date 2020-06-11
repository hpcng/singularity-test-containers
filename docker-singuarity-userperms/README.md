# docker-singularity-userperms

This is a test container for Singularity issue #977.

If a docker container holds a file or directory without owner write perms, and singularity build is run as a user (non-root), we must force owner write perms at extraction. If we don't do this, the file or dir in question cannot be modified at later layers, and build may fail.


**Expected Behaviour, fixed in PR #1295**

Container builds OK, and on run there is nothing listed inside /testdir.

```
$ singularity pull docker://dctrud/docker-singularity-userperms
WARNING: pull for Docker Hub is not guaranteed to produce the
WARNING: same image on repeated pull. Use Singularity Registry
WARNING: (shub://) to pull exactly equivalent images.
Docker image path: index.docker.io/dctrud/docker-singularity-userperms:latest
Cache folder set to /home/dave/.singularity/docker
Importing: base Singularity environment
WARNING: Building container as an unprivileged user. If you run this container as root
WARNING: it may be missing some functionality.
Building Singularity FS image...
Building Singularity SIF container image...
Singularity container built: ./docker-singularity-userperms.simg
Cleaning up...
Done. Container is at: ./docker-singularity-userperms.simg

$ singularity run docker-singularity-userperms.simg 
/testdir
```

**Prior Behaviour**

```
$ singularity pull docker://dctrud/docker-singularity-userperms
WARNING: pull for Docker Hub is not guaranteed to produce the
WARNING: same image on repeated pull. Use Singularity Registry
WARNING: (shub://) to pull exactly equivalent images.
Docker image path: index.docker.io/dctrud/docker-singularity-userperms:latest
Cache folder set to /home/dave/.singularity/docker
Importing: base Singularity environment
ERROR  : Error applying whiteout marker from docker layer.
ABORT  : Retval = 255
Cleaning up...
rm: cannot remove '/tmp/.singularity-build.HkwFPi/testdir/testfile': Permission denied
ERROR: pulling container failed!
```