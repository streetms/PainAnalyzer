cmake_minimum_required(VERSION 3.21)
project(PainApp LANGUAGES CXX)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
option(BUILD_FRONTEND "Build frontend" OFF)
option(BUILD_BACKEND "Build backend" OFF)
include(FetchContent)

FetchContent_Declare(
        nlohmann_json
        URL https://github.com/nlohmann/json/releases/download/v3.12.0/json.tar.xz
)
FetchContent_MakeAvailable(nlohmann_json)

add_subdirectory(common)
if(BUILD_FRONTEND)
    add_subdirectory(frontend)
endif()

if(BUILD_BACKEND)
    add_subdirectory(backend)
    FetchContent_Declare(
            cpp_dotenv
            URL https://github.com/adeharo9/cpp-dotenv/archive/refs/tags/v1.0.0-alpha.tar.gz
    )
    FetchContent_MakeAvailable(cpp_dotenv)
endif()

#add_subdirectory(backend EXCLUDE_FROM_ALL)
