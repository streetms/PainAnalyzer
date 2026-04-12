cmake_minimum_required(VERSION 3.21)
project(PainApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
option(BUILD_FRONTEND "Build frontend" OFF)
option(BUILD_BACKEND "Build backend" OFF)
include(FetchContent)

FetchContent_Declare(
        nlohmann_json
        GIT_REPOSITORY https://github.com/nlohmann/json.git
        GIT_TAG v3.12.0
)

FetchContent_MakeAvailable(nlohmann_json)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/common/include)
if(BUILD_FRONTEND)
    add_subdirectory(frontend/core)
    add_subdirectory(frontend/patient)
endif()

if(BUILD_BACKEND)
    add_subdirectory(backend)
endif()

#add_subdirectory(backend EXCLUDE_FROM_ALL)
