FROM trzeci/emscripten

RUN apt-get -qq -y update && apt-get -qq install -y pkgconf

RUN wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz \
    && tar xvzf openssl-*.tar.gz \
    && mv openssl-1.0.2o /src/openssl

RUN    cd /src/openssl && export CC=emcc \
    && export CXX=emcc \
    && export LINK=${CXX} \
    && export ARCH_FLAGS="" \
    && export ARCH_LINK="" \
    && export CPPFLAGS=" ${ARCH_FLAGS} " \
    && export CXXFLAGS=" ${ARCH_FLAGS} " \
    && export CFLAGS=" ${ARCH_FLAGS} " \
    && export LDFLAGS=" ${ARCH_LINK} " \
    && ./Configure linux-generic32 no-threads no-asm \
    && make -j8; exit 0

WORKDIR /src/
COPY ./ ./

RUN make

RUN echo "#!/bin/bash\n \
# set -e\n \
# rm -rf /output/*\n \
cp -r /src/dtls.js /output/\n \
cp -r /src/dtls.wasm /output/\n \
" >> copy.sh && chmod 777 copy.sh

ENTRYPOINT ["./copy.sh"]
CMD []