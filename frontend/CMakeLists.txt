#include(${CMAKE_SOURCE_DIR}/cmake/conan_bootstrap.cmake)
#project(PainAnalyzerPatient)

find_package(nlohmann_json)

add_subdirectory(libs/core)
add_subdirectory(libs/shared_ui)
add_subdirectory(patient)