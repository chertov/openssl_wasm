FROM trzeci/emscripten

RUN apt-get -qq -y update
RUN apt-get -qq install -y \
        pkgconf

WORKDIR /src/

RUN wget https://www.openssl.org/source/openssl-1.0.2o.tar.gz \
    && tar xvzf openssl-*.tar.gz \
    && mv openssl-1.0.2o openssl

WORKDIR /src/openssl

RUN    export CC=emcc \
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

# RUN export CC=emcc \
#     && ./Configure -no-asm no-test no-unit-test linux-generic32 \
#     && make

# RUN wget https://www.openssl.org/source/openssl-1.1.0h.tar.gz \
#     && tar xvzf openssl-*.tar.gz \
#     && mv openssl-1.1.0h openssl
# WORKDIR /src/openssl

# RUN export CC=emcc \
#     && ./Configure -no-asm -no-ssl3 -no-comp -no-shared -no-hw -no-threads -no-dso -no-engine -no-deprecated linux-generic32 \
#     && make -j8

# RUN export CC=emcc \
#     && ./Configure -no-asm -no-apps -no-shared -no-hw -no-threads -no-dso -no-deprecated linux-generic32 \
#     && make -j8

# RUN git clone https://github.com/openssl/openssl.git

# WORKDIR /src/openssl


# RUN git checkout OpenSSL_1_0_2a
# RUN ./Configure -no-asm -no-apps no-ssl2 no-ssl3 no-comp no-hw no-engine no-deprecated shared no-dso linux-generic32
# RUN emmake bash \
#     && make -j8

# RUN emmake bash \
#     && ./Configure -no-asm -no-ssl3 -no-comp -no-shared -no-hw -no-threads -no-dso --openssldir=built linux-generic32 \
#     && make -j8

WORKDIR /src/
COPY ./ ./

# RUN emcc -L./openssl -I./openssl/include dtls.c -s WASM=1 -o dtls.html -lssl -lcrypto --emrun
RUN make
RUN ls


RUN echo "#!/bin/bash\n \
# set -e\n \
# rm -rf /output/*\n \
cp -r /src/dtls.js /output/\n \
cp -r /src/dtls.wasm /output/\n \
cp -r /src/dtls.html /output/\n \
" >> copy.sh && chmod 777 copy.sh

ENTRYPOINT ["./copy.sh"]
CMD []