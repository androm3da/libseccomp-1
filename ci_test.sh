#!/bin/sh -ex

# This is a script for a continuous integration test service
# So far, it works on:
# - http://codeship.io/


build_and_test_asan()
{
    export CFLAGS="-g -O2 -fsanitize=address -fno-omit-frame-pointer"
    export ASAN_OPTIONS="malloc_context_size=20:quarantine_size_mb=512"
    export LDFLAGS="-fsanitize=address"

    ./autogen.sh  \
            && ./configure --enable-python \
            && make --always-make check
}

build_and_test_ubsan()
{
    export CFLAGS="-g -O2 -fsanitize=undefined -fno-omit-frame-pointer"
    export LDFLAGS="-fsanitize=undefined"

    ./autogen.sh  \
            && ./configure --enable-python \
            && make --always-make check
}

install_check_py()
{
    sudo make install
    python -c 'import seccomp'
}

build_and_test_asan
build_and_test_ubsan
# install_check_py

