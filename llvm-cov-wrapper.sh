#!/bin/sh
if [ "$1" = "-v" ]; then
    echo "llvm-cov-wrapper 4.2.1"
    exit 0
else
    /usr/bin/gcov "$@"
fi
