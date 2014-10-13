#!/bin/bash

run() {
    veval docker run -v /usr/local/rvm --name rvm rvm
}
