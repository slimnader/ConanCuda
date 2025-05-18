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

#function cmd_bootstrap() {
#  python_bin="$(find . -mindepth 1 -maxdepth 4 | grep 'bin/activate$'| head -n1)"
#  root_cmake= $(find . )
#  if [ -s "$python_bin" ];then
#    echo "found py bin ${python_bin}"
#  else
#
#  fi
#}



function cmd_release() {
#    path="$PWD/venv_linux/bin:$PATH:$PATH"
#    export PATH=$path
#    cmake -S . -B release \
#      -DCMAKE_BUILD_TYPE=Release \
#      -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="$PWD/conan_provider.cmake" \
#      -DCONAN_COMMAND="$PWD/venv_linux/bin/conan"
#
#    # build
#    cmake --build release --config Release -- -j"$(nproc)" VERBOSE=1
venv_bin_folder="$(find . -type d | grep 'bin$'| sed 's/\.//g')"
    conan_command=""
    if [[ ! -z $venv_bin_folder ]]; then
        path="${PWD}venv_linux/bin:$PATH:$PATH"
        conan_command="$PWD$venv_bin_folder/conan"
    else
      conan_command=$(which conan)
    fi
    path="$PWD/venv_linux/bin:$PATH:$PATH"
    export PATH=$path
    cmake -S . -B release \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="${PWD}conan_provider.cmake" \
      -DCONAN_COMMAND="${PWD}venv_linux/bin/conan"

    # build
    cmake --build release --config Release -- -j"$(nproc)" VERBOSE=1
}

function cmd_test(){
  echo Tester
}

eval "cmd_$1"
