FROM alpine:latest as builder

RUN apk add --no-cache --update-cache --upgrade \
  autoconf \
  automake \
  curl \
  fuse-dev \
  g++ \
  make \
  tar

ARG RAR_VERSION=5.8.3
ARG RAR2FS_VERSION=1.28.0

RUN curl -L -O "https://www.rarlab.com/rar/unrarsrc-$RAR_VERSION.tar.gz" && \
  curl -L -O "https://github.com/hasse69/rar2fs/releases/download/v$RAR2FS_VERSION/rar2fs-$RAR2FS_VERSION.tar.gz"

WORKDIR /rar2fs

RUN tar --strip-components 1 -xzvf "/rar2fs-$RAR2FS_VERSION.tar.gz" && \
  tar xzvf "/unrarsrc-$RAR_VERSION.tar.gz"

WORKDIR /rar2fs/unrar

RUN make lib

WORKDIR /rar2fs

RUN autoreconf -f -i && ./configure && make

FROM alpine:latest

ARG FUSE_THREAD_STACK=320000
ENV FUSE_THREAD_STACK $FUSE_THREAD_STACK

RUN apk add --no-cache --update-cache --upgrade \
  fuse \
  libstdc++

COPY --from=builder /rar2fs/src/rar2fs /usr/local/bin/rar2fs

ENTRYPOINT [ "rar2fs" ]

CMD [ "-f", "-o", "allow_other", "-o", "auto_unmount", "--seek-length=1", "/source", "/destination" ]
