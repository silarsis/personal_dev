#!/bin/bash

run() {
    veval docker run -v /usr/local/lib/ruby/gems --name gems gems
}
