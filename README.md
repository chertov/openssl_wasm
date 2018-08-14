Simple script to build openssl and C code from 'openssl' directory with emscripten inside docker container. 
```sh
https://github.com/chertov/openssl_wasm.git
cd openssl_wasm
./build.sh
```

```sh
$ ls -lh ./output
total 12800
-rw-r--r--  1 user  staff   3.0M Aug 14 20:33 dtls.js
-rw-r--r--  1 user  staff   2.8M Aug 14 20:33 dtls.wasm
```
