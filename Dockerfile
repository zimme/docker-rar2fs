ARG BUILDER_IMAGE=alpine:3.21.2
ARG RUNTIME_IMAGE=alpine:3.21.2

FROM $BUILDER_IMAGE AS builder

RUN apk add --no-cache --update-cache --upgrade \
  autoconf \
  automake \
  curl \
  fuse-dev \
  g++ \
  make \
  tar

ARG UNRAR_VERSION=7.1.10
ARG RAR2FS_VERSION=1.29.7

RUN curl --location --remote-name --remote-header-name "https://www.rarlab.com/rar/unrarsrc-$UNRAR_VERSION.tar.gz"
RUN curl --location --remote-name --remote-header-name "https://github.com/hasse69/rar2fs/archive/refs/tags/v$RAR2FS_VERSION.tar.gz"

WORKDIR /rar2fs

RUN tar --strip-components 1 --extract --gzip --verbose --file "/rar2fs-$RAR2FS_VERSION.tar.gz" 
RUN tar --extract --gzip --verbose --file "/unrarsrc-$UNRAR_VERSION.tar.gz"

WORKDIR /rar2fs/unrar

RUN make lib

WORKDIR /rar2fs

RUN autoreconf --force --install && ./configure && make

FROM $RUNTIME_IMAGE

ARG FUSE_THREAD_STACK=320000
ENV FUSE_THREAD_STACK=$FUSE_THREAD_STACK

RUN apk add --no-cache --update-cache --upgrade \
  fuse \
  libstdc++

COPY --from=builder /rar2fs/src/rar2fs /usr/local/bin/rar2fs

ENTRYPOINT [ "rar2fs" ]

HEALTHCHECK --interval=5s --timeout=3s \
  CMD grep -qs rar2fs /proc/mounts

CMD [ "-f", "-o", "allow_other", "-o", "auto_unmount", "--seek-length=1", "/source", "/destination" ]
