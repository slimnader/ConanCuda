# Source directory: my_cuda_app/src/CMakeLists.txt
#string(TOLOWER "${CMAKE_BUILD_TYPE}" type)
include(${CMAKE_SOURCE_DIR}/helpers.cmake)
include(./packages.cmake)
set(name ConanCuda)
message("BINARY DIR ${CMAKE_BINARY_DIR}  build type -  ${type}")


find_nccl()

file(GLOB_RECURSE LIB_SOURCES "lib/*.cpp")
file(GLOB_RECURSE LIB_HEADERS "lib/*.h" "lib/*.hpp")



# Copy the resources folder to build directory at build-time
add_custom_target(copy_resources ALL
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/resources"
        "${CMAKE_BINARY_DIR}/resources"
        COMMENT "Copying resources into build"
)

add_executable(${name} main.cu ${LIB_SOURCES} ${LIB_HEADERS})

add_dependencies(${name} copy_resources)


# Position‑independent for shared‑lib deps & sanitizers
set_target_properties(${name} PROPERTIES
        POSITION_INDEPENDENT_CODE ON
        CUDA_SEPARABLE_COMPILATION ON
        CUDA_ARCHITECTURES "${CMAKE_CUDA_ARCHITECTURES}"
        COMPILE_OPTIONS -G
)


target_link_all_packages("${CONANDEPS_LEGACY}" "${name}")

target_include_directories(${name} PRIVATE ${NCCL_INCLUDE_DIR})
target_link_libraries( ${name} PRIVATE NCCL::NCCL)

#CUDA TOOLKIT LIBS - OPTIONAL, Uncomment if needed
#target_link_libraries(${name} PRIVATE cublas)
#target_link_libraries(${name} PRIVATE cufft)
#target_link_libraries(${name} PRIVATE cusparse)
#target_link_libraries(${name} PRIVATE curand)
