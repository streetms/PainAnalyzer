cmake_minimum_required(VERSION 3.21)
project(PainApp LANGUAGES CXX)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
option(BUILD_FRONTEND "Build frontend" OFF)
option(BUILD_BACKEND "Build backend" OFF)


include(dependencies.cmake)
add_subdirectory(common)
if(BUILD_FRONTEND)
    add_subdirectory(frontend)
endif()

if(BUILD_BACKEND)
    set(CMAKE_CXX_STANDARD 23)
    add_subdirectory(backend)
endif()
