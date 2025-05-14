#!/bin/bash


#path="$PWD/venv_linux/bin:$PATH:$PATH"
#
#export PATH=$path
#
#cmake -S . -B release \
#  -DCMAKE_BUILD_TYPE=Release \
#  -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=conan_provider.cmake \
#  -DCONAN_COMMAND="$PWD/venv_linux/bin/conan"
#
## build
#cmake --build release --config Release -- -j"$(nproc)" VERBOSE=1


function cmd_release() {
    path="$PWD/venv_linux/bin:$PATH:$PATH"

    export PATH=$path

    cmake -S . -B release \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=conan_provider.cmake \
      -DCONAN_COMMAND="$PWD/venv_linux/bin/conan"

    # build
    cmake --build release --config Release -- -j"$(nproc)" VERBOSE=1
}

function cmd_test(){
  echo Tester
}

eval "cmd_$1"
