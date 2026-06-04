cmake_minimum_required(VERSION 3.21)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
option(BUILD_FRONTEND "Build frontend" OFF)
option(BUILD_BACKEND "Build backend" OFF)

if(BUILD_FRONTEND)
    set(CONAN_OPTIONS
            -o with_client=True
            -o with_server=False
    )
endif()
if(BUILD_BACKEND)
    set(CONAN_OPTIONS
            -o with_client=False
            -o with_server=True
    )
endif()

message(----------------------------
        ${CONAN_PROFILE}
        ----------------------------)
include(${CMAKE_SOURCE_DIR}/cmake/conan_bootstrap.cmake)
project(PainAnalyzer)

if(BUILD_FRONTEND)
    add_subdirectory(frontend)
endif()

if(BUILD_BACKEND)
    set(CMAKE_CXX_STANDARD 23)
    add_subdirectory(backend)
endif()
