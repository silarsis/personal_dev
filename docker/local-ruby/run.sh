#!/bin/bash

run() {
    veval docker run -v /usr/local/ruby --name ruby ruby
}
