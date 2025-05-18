# ConanCuda
Boilerplate Code for a Cuda + NCCL Conan project

## Table of Contents
- [Requirements](#requirements)
    - [Platform Support](#platform-support)
    - [Configuration](#configuration)
- [Getting Started](#getting-started)
- [Conan Libraries](#conan-libraries)
- [Toolchain Environment Variables](#toolchain-environment-variables)
- [NCCL](#nccl)


## Requirements

### Platform Support

| Operating System         | Status               |
|--------------------------|----------------------|
| Linux (any distro)       | ✅ Supported         |
| Windows (WSL 2 only)     | ✅ Supported via WSL2|
| Windows (native)         | ❌ Not supported     |
| macOS                    | ❌ Not supported     |


> ⚠️ **Note:** Native Windows is not supported—please run under WSL 2 on Windows.

### Configuration
- **CMake** ≥ 3.20
- **CUDA Toolkit** ≥ 11.4 (for GPU builds)
- **GCC** ≥ 9.3 (or Clang 12+)
- **Python** ≥ 3.8 
- **libnccl2, libnccl-dev** ≥ 2.x.x (*Optional - see [NCCL SECTION](#nccl)*) 


## Getting Started

### Simple Build Script
```shell
    venv_bin_folder="$(find . -type d | grep 'bin$'| sed 's/\.//g')"
    conan_command="" 
    if [[ ! -z $venv_bin_folder ]]; then
        path="$PWD/venv_linux/bin:$PATH:$PATH"
        export PATH=$path
        conan_command="$PWD$venv_bin_folder/conan"
    else 
      conan_command=$(which conan)
    fi
    export PATH=$path
    cmake -S . -B debug \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES="$PWD/conan_provider.cmake" \ 
      -DCONAN_COMMAND="$PWD/venv_linux/bin/conan"

    # build
    cmake --build release --config Release -- -j"$(nproc)" VERBOSE=1
```

## Conan Libraries

*Any external libraries you need are configured in: [conandata.yml](./conandata.yml)* as the single source of truth for any external libraries (NOT INCLUDING NCCL)

Example:
```yaml
requirements:
  - "conan_lib/version"

```
## Toolchain Environment Variables:
*Set the toolchain env variables in [conanfile.py](./conanfile.py#L15)*

Example:
```python
cached_env_vars = {
    "CMAKE_CUDA_ARCHITECTURES": "80 86 87",
    "CMAKE_CUDA_FLAGS": ("--extended-lambda --threads 4"),
    "CMAKE_POSITION_INDEPENDENT_CODE": "ON"
}
```
***NOTE: These are mainly for nvcc cmake configurations***

## NCCL

**NCCL dependencies arent managed by conan**

This dependency is optional and can be disabled by commenting out 
```cmake
find_nccl()
```
**AND**

```cmake
target_link_libraries( ${name} PRIVATE NCCL::NCCL)
```



in [src/CMakeLists.txt](./src/CMakeLists.txt) 
