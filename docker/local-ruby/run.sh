#!/bin/bash

run() {
    veval "${RUN_DOCKER}" -v /usr/local/ruby --name ruby ruby
}
