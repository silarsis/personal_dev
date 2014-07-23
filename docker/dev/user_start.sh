#!/bin/bash
(( $# == 0 )) && exec /bin/bash || exec /bin/bash -c "$@"
