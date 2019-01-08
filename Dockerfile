FROM alpine as builder

RUN apk add --no-cache --purge -uU \
  curl \
  fuse-dev \
  g++ \
  make \
  tar

ENV RAR_VERSION="${RAR_VERSION:-5.6.8}"
ENV RAR2FS_VERSION="${RAR2FS_VERSION:-1.27.1}"

RUN curl -L -O "https://www.rarlab.com/rar/unrarsrc-${RAR_VERSION}.tar.gz"

RUN curl -L -O "https://github.com/hasse69/rar2fs/releases/download/v${RAR2FS_VERSION}/rar2fs-${RAR2FS_VERSION}.tar.gz"

RUN tar xzvf "unrarsrc-${RAR_VERSION}.tar.gz"

RUN mkdir rar2fs

RUN tar -C /rar2fs --strip-components 1 -xzvf "rar2fs-${RAR2FS_VERSION}.tar.gz"

WORKDIR /unrar

RUN make lib; make install-lib

WORKDIR /rar2fs

RUN ./configure --with-unrar=../unrar --with-unrar-lib=/usr/lib/

RUN make

FROM alpine

RUN apk add --no-cache --purge -uU \
  fuse \
  libstdc++

COPY --from=builder /rar2fs/rar2fs /usr/local/bin/rar2fs

VOLUME [ "/source", "/destination" ]

ENTRYPOINT [ "rar2fs" ]

CMD [ "-f", "--seek-length=1", "-o", "allow_other", "/source", "/destination" ]
