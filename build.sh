#!/bin/bash

echo "�� Building WebAssembly..."
cd client
wasm-pack build --target web --out-dir ../static
cd ..

echo "�� Starting server..."
cargo run -p server
