cmake_minimum_required(VERSION 3.21)

if(NOT CMAKE_TOOLCHAIN_FILE
        AND DEFINED CONAN_CMD
        AND DEFINED CONAN_PROFILE)

    message(STATUS "Conan: ${CONAN_CMD}")
    message(STATUS "Conan profile: ${CONAN_PROFILE}")

    set(CONAN_TOOLCHAIN
            "${CMAKE_BINARY_DIR}/conan_toolchain.cmake"
    )

    set(CONAN_OPTIONS "")

    if(BUILD_FRONTEND)
        list(APPEND CONAN_OPTIONS
                "-o" "with_client=True"
                "-o" "with_server=False"
        )
    endif()

    if(BUILD_BACKEND)
        list(APPEND CONAN_OPTIONS
                "-o" "with_client=False"
                "-o" "with_server=True"
        )
    endif()

    execute_process(
            COMMAND
            ${CONAN_CMD}
            install
            ${CMAKE_SOURCE_DIR}
            --output-folder=${CMAKE_BINARY_DIR}
            --profile:host=${CONAN_PROFILE}
            --build=missing
            -s
            build_type=${CMAKE_BUILD_TYPE}
            ${CONAN_OPTIONS}
            RESULT_VARIABLE CONAN_RESULT
    )

    if(NOT CONAN_RESULT EQUAL 0)
        message(FATAL_ERROR "Conan install failed")
    endif()

    if(NOT EXISTS "${CONAN_TOOLCHAIN}")
        message(FATAL_ERROR
                "Conan toolchain was not generated:\n"
                "${CONAN_TOOLCHAIN}"
        )
    endif()

    # ConanDeps/ConanToolchain adds the paths needed by find_package().
    include("${CONAN_TOOLCHAIN}")
    if(ANDROID)
        set(CONAN_RUNTIME_LIB_DIRS "")
    endif()

endif()

project(PainAnalyzer LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(BUILD_FRONTEND "Build frontend" OFF)
option(BUILD_BACKEND "Build backend" OFF)

if(BUILD_FRONTEND)
    add_subdirectory(frontend)
endif()

if(BUILD_BACKEND)
    add_subdirectory(backend)
endif()