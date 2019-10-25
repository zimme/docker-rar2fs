# zimme/rar2fs

Minimal [`rar2fs`] image based on alpine.

The image will run `rar2fs` with `-o allow_other -o auto_unmount
--seek-length=1` by default.

Bind-mount your rar files on `/source` and bind-mount an empty folder on
`/destination` to hold the rar2fs mount, and make sure you set the
bind-propagation to `shared`/`rshared`.

The image will run `rar2fs` as `root`. I recommend overriding this
using the `-u` and/or `--group-add` flags of docker run.

I recommend using `--init` when running this image.

You will need to add capabilities `MKNOD` and `SYS_ADMIN` as well as
providing the `/dev/fuse` device to the container for it to be able to
mount a fuse fs like rar2fs.

If your docker host is using `apparmor` the following flag,
`--security-opt apparmor:unconfined`, might be needed to have
permission to use fuse within the container.

## Usage

```sh
docker run \
  -d \
  --init \
  --name rar2fs \
  --cap-add MKNOD \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --network none \
  -v <path/to/rar/files>:/source \
  -v <path/to/empty/folder>:/destination:rshared \
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
  --cap-add MKNOD \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --network none \
  -v <path/to/rar/files>:/source \
  -v <path/to/empty/folder>:/destination:rshared \
  zimme/rar2fs \
  <custom rar2fs option> \
  -o <custom fuse option> \
  /source \
  /destination
```

## Docker Compose

You can find an example of a docker-compose file [here][docker-compose.yml].

[docker-compose.yml]: https://github.com/zimme/docker-rar2fs/blob/master/docker-compose.example.yml
[`rar2fs`]: https://github.com/hasse69/rar2fs
