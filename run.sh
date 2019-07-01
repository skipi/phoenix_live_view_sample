#!/bin/bash
set -ex
mix do deps.get, deps.compile

cd assets && npm install
cd ..

mix phx.server