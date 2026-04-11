cmake_minimum_required(VERSION 3.21)
project(PainApp LANGUAGES CXX)
option(BUILD_FRONTEND "Build frontend" OFF)
option(BUILD_BACKEND "Build backend" OFF)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/common/include)
message("-----" ${CMAKE_CURRENT_SOURCE_DIR}/common/include"-----" )
if(BUILD_FRONTEND)
    add_subdirectory(frontend/core)
    add_subdirectory(frontend/patient)
endif()

if(BUILD_BACKEND)
    add_subdirectory(backend)
endif()

#add_subdirectory(backend EXCLUDE_FROM_ALL)
