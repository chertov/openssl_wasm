#!/bin/bash
set -e
if [ ! -d $(pwd)/output/ ]; then mkdir -p $(pwd)/output/; fi

# copy sources to image
docker build -t wasm_builder -f $(pwd)/build.Dockerfile $(pwd)/openssl/

# copy binary firmware to output
docker run -it -v $(pwd)/output/:/output/ wasm_builder