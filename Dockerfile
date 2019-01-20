FROM alpine as builder

RUN apk add --no-cache --purge -uU --virtual build-deps \
  curl \
  fuse-dev \
  g++ \
  make \
  tar

ARG RAR_VERSION=5.6.8
ARG RAR2FS_VERSION=1.27.1

RUN curl -L -O "https://www.rarlab.com/rar/unrarsrc-${RAR_VERSION}.tar.gz"

RUN curl -L -O "https://github.com/hasse69/rar2fs/releases/download/v${RAR2FS_VERSION}/rar2fs-${RAR2FS_VERSION}.tar.gz"

RUN tar xzvf "unrarsrc-${RAR_VERSION}.tar.gz"

RUN mkdir rar2fs

RUN tar -C /rar2fs --strip-components 1 -xzvf "rar2fs-${RAR2FS_VERSION}.tar.gz"

WORKDIR /unrar

RUN ./configure

RUN make lib; make install-lib

WORKDIR /rar2fs

RUN ./configure --with-unrar=../unrar --with-unrar-lib=/usr/lib/

RUN make

RUN apk del build-deps

FROM alpine

RUN apk add --no-cache --purge -uU \
  fuse \
  libstdc++

COPY --from=builder /rar2fs/rar2fs /usr/local/bin/rar2fs

STOPSIGNAL SIGQUIT

ENTRYPOINT [ "rar2fs" ]

CMD [ "-f", "-o", "allow_other", "-o", "auto_unmount", "--seek-length=1", "/source", "/destination" ]
