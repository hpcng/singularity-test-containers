# docker-aufs-sanity

[![Docker Pulls](https://img.shields.io/docker/pulls/dctrud/docker-aufs-sanity.svg)](https://hub.docker.com/r/dctrud/docker-aufs-sanity/)

This repo contains a Dockerfile defining the container `dctrud/docker-aufs-sanity` on [docker hub](https://hub.docker.com/r/dctrud/docker-aufs-sanity/).

This is a small docker container that can be used to test container software that extracts docker multi-layer images (e.g. Singularity), to ensure that they handle aufs whiteout correctly.

If your extraction of docker layers handles whiteout correctly then you should see the following when you run the container:

```bash
$ docker run dctrud/docker-aufs-sanity
/test
/test/normal-dir
/test/normal-dir/file1
/test/normal-dir/file2
/test/whiteout-dir
/test/whiteout-dir/file2
/test/whiteout-file
/test/whiteout-file/file2
```

If your aufs extraction is incorrect you will likely see an additional `file1` inside the directories `whiteout-dir/`, `whiteout-file/`, or both. You will also likely see the whiteout marker files (beginning `.wh.`) E.g. with Singularity v2.4:

```bash
$ singularity run docker://dctrud/docker-aufs-sanity
/test
/test/normal-dir
/test/normal-dir/file1
/test/normal-dir/file2
/test/whiteout-dir
/test/whiteout-dir/file1
/test/whiteout-dir/.wh.file1
/test/whiteout-dir/file2
/test/whiteout-file
/test/whiteout-file/file1
/test/whiteout-file/file2
/test/whiteout-file/.wh.file1
/test/.wh.whiteout-dir
```


## Explanation

Each Dockerfile `RUN` step creates a separate container filesystem layer, with content that builds upon previous layers. When you `rm` a file inside a `RUN` step it must be removed from your container - but the `RUN` cannot modify the previous immutable layers. Docker uses the aufs whiteout standard to record when you `rm` a file that was created in a previous layer. If you create a file `file1` in layer 1, and remove it in layer 2, then the tar for layer 2 will contain a hidden marker file `.wh.file1` which tells us we should remove `file1` as we extract layer 2.

### About this test

Here we create 3 directories to test directory, file, and no whiteout.

**Directory Whiteout**

Directory `/test/whiteout-dir/` is created, and has a single file, `file1` added inside it.

We then remove `file1` and `/test/whiteout-dir/` itself. At this point there is no `/test/whiteout-dir/` visible in our container. Docker will mark this by creating a whiteout file `/test/.wh.whiteout-dir` in the layer tar, which instructs the extracting tool to remove the directory during extraction, just as we did in our Dockerfile RUN steps.

Finally we recreate `/test/whiteout-dir/` and put a new file `file2` into it.

If we extract our container layers correctly we should see `/test/whiteout-dir/` containing a single file named `file2`.


**File Whiteout**

Directory `/test/whiteout-file/` is created, and has a single file, `file1` added inside it. In a later RUN step we add a new file `file2` into the directory.

Finally, we remove `/test/whiteout-file/file1` in a RUN step. Docker will mark this by creating a whiteout file `/test/whiteout-file/.wh.file1` in the layer tar, which instructs the extracting tool to remove `file1` during extraction, just as we did in our Dockerfile RUN steps.

If we extract our container layers correctly we should see `/test/whiteout-file/` containing a single file named `file2`.

**No Whiteout**

Directory `/test/normal-dir/` has two files, `file1` and `file2`, added to it with no removals made in later RUN steps.

If we extract our container layers correctly we should see `/test/normal-dir/` containing both `file1` and `file2`.

