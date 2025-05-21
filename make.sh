#!/bin/bash

conan_command=$(realpath "$(find . -type f -path '*/bin/conan' -print -quit)" 2>/dev/null)
venv=$(realpath "$(find . -type f -path '*/bin/activate' -print -quit)" 2>/dev/null)

function cmd_release() {
    source $venv
    path="$venv:$PATH:$PATH"
    export PATH=$path
    cmake -S . -B release \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="${PWD}/conan_provider.cmake" \
      -DCONAN_COMMAND="$conan_command"

    # build
    cmake --build release --config Release -- -j"$(nproc)" VERBOSE=1
}

function cmd_test(){
  echo Tester
}

eval "cmd_$1"
