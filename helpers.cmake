
function(get_package_list packages)
    execute_process(
            COMMAND bash -c "python3  ${CMAKE_SOURCE_DIR}/conandata.py find_packages"
            OUTPUT_VARIABLE package_list
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(
            ${packages} # output variable
            "${package_list}" #list casted as string delimited by ;
            PARENT_SCOPE
    )
endfunction()

function(get_upstream_recipes recipes)
    execute_process(
            COMMAND bash -c "python3  ${CMAKE_SOURCE_DIR}/conandata.py upstream_recipes"
            OUTPUT_VARIABLE recipe_list
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(
            ${recipes} # output variable
            "${recipe_list}" #list casted as string delimited by ;
            PARENT_SCOPE
    )
endfunction()

function(find_packages packages)
    message(STATUS "finding packages ${packages}")
    foreach (package IN LISTS packages)
        message(STATUS "Finding package ${package}")
        find_package(${package})
    endforeach ()
endfunction()

function(target_link_all_packages recipes project_name)
    message("to be linked: ${recipes} to ${project_name}")
    foreach (recipe IN LISTS recipes)
        message(STATUS "linking ${recipe} to ${package_name}")
        target_link_libraries(${project_name} PRIVATE "${recipe}")
    endforeach ()
endfunction()

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


