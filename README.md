# zimme/rar2fs

Minimal `rar2fs` image based on alpine.

This Docker image will run `rar2fs` with `-o allow_other -o auto_unmount
--seek-length=1` by default.

Bind-mount your rar files on `/source` and bind-mount an empty folder on
`/destination` to hold the rar2fs mount.

The image will run `rar2fs` as `root`. I recommend to override this
using the -u and/or --group-add of docker run.

I recommend using `--init` when running this image.

## Usage

```sh
docker run \
  -d \
  --init \
  --name rar2fs \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  -v <path/to/rar/files:/source \
  -v <path/to/empty/folder>:/destination \
  zimme/rar2fs
```

## Config

To get a list of all config options for `rar2fs` run the following
command.

```sh
docker run --rm zimme/rar2fs --help
```

To run this image with your own config provide your config arguments as
arguments to the image when running.

```sh
docker run \
  -d \
  --init \
  --name rar2fs \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  -v <path/to/rar/files:/source \
  -v <path/to/empty/folder>:/destination \
  zimme/rar2fs \
  <custom rar2fs option> \
  -o <custom fuse option> \
  /source \
  /destination
```
