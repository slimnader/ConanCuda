cmake_minimum_required(VERSION 3.24 FATAL_ERROR)

project(ConanCuda LANGUAGES C CXX CUDA)


# Conan will define these in CMakeToolchain; keep defaults tiny
include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake OPTIONAL)

# ---- Global compile options ----
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 17)

add_subdirectory(src)




