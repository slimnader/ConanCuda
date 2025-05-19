
function(load_conan_deps)
    execute_process(
            COMMAND bash -c [=[
            conan install . --output-folder=./test_folder --build=missing  \
            && mv ./test_folder/build-release/conan/conandeps_legacy.cmake ./src/packages.cmake  \
            && chmod -x ./src/packages.cmake \
            && sed -i '1i\\'  ./src/packages.cmake \
            && sed -i '1i\#This is a generated cmake copy of conandeps_legacy\.cmake'  ./src/packages.cmake \
            && printf '\n\n%s\n' "$(python3 conanfile.py cached_vars_force)">>./src/packages.cmake \
            && rm -rf ./test_folder

    ]=]
            WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endfunction()

function(target_link_all_packages recipes project_name)
    message("to be linked: ${recipes} to ${project_name}")
    foreach (recipe IN LISTS recipes)
        message(STATUS "linking ${recipe} to ${project_name}")
        target_link_libraries(${project_name} PRIVATE "${recipe}")
    endforeach ()
endfunction()


#FOR NCCL exclusively

function(find_nccl)
    # 1) look for the header
    find_path(NCCL_INCLUDE_DIR
            NAMES  nccl.h
            HINTS  ENV NCCL_ROOT
            /usr/include
            /usr/local/include
    )
    # 2) look for the library
    find_library(NCCL_LIBRARY
            NAMES  nccl
            HINTS  ENV NCCL_ROOT
            /usr/lib
            /usr/lib/x86_64-linux-gnu
            /usr/local/lib
    )

    # 3) error out if we didn’t find it
    if(NOT NCCL_INCLUDE_DIR OR NOT NCCL_LIBRARY)
        message(FATAL_ERROR
                "Could not find NCCL (nccl.h or libnccl). "
                "Please install libnccl-dev or set NCCL_ROOT."
        )
    endif()

    # 4) define an IMPORTED target
    add_library(NCCL::NCCL INTERFACE IMPORTED)
    set_target_properties(NCCL::NCCL PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${NCCL_INCLUDE_DIR}"
            INTERFACE_LINK_LIBRARIES        "${NCCL_LIBRARY}"
    )

    # 5) export the include path back to the parent scope
    set(NCCL_INCLUDE_DIR "${NCCL_INCLUDE_DIR}" PARENT_SCOPE)
    set(NCCL_LIBRARY     "${NCCL_LIBRARY}"     PARENT_SCOPE)
endfunction()


