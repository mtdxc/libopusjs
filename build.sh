#!/bin/bash
# usage: ./build.sh [flags]
if [ ! -e opus ]; then
  git clone -b v1.3.1 https://github.com/xiph/opus.git
  pushd opus
  ./autogen.sh
  emconfigure ./configure --disable-rtcd --disable-intrinsics --disable-shared \
    --enable-static  --disable-stack-protector --disable-hardening
  emmake make -j$(nproc)
  popd
fi

# asm.js release flags: -O2 --memory-init-file 0
# wasm release flags: -O2 -s WASM=1 -s ALLOW_MEMORY_GROWTH=1
em++ api.cpp -Iopus/include -Lopus/.libs -lopus --pre-js preapi.js \
  --post-js api.js -s EXPORTED_FUNCTIONS='["_free"]' $@ -o libopus.js
