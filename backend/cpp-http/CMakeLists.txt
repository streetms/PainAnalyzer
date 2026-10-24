cmake_minimum_required(VERSION 3.21)
project(cpp-http VERSION 0.1.0 LANGUAGES CXX)

include(CTest)
find_package(Boost REQUIRED)

add_library(cpphttp
    src/request.cpp
    src/response.cpp
    src/router.cpp
    src/session.cpp
    src/server.cpp
)
target_compile_features(cpphttp PUBLIC cxx_std_20)
target_include_directories(cpphttp
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)
if(TARGET Boost::headers)
    target_link_libraries(cpphttp PUBLIC Boost::headers)
elseif(TARGET Boost::boost)
    target_link_libraries(cpphttp PUBLIC Boost::boost)
endif()

if(BUILD_TESTING)
    add_executable(cpphttp_tests tests/router_tests.cpp)
    target_link_libraries(cpphttp_tests PRIVATE cpphttp)
    add_test(NAME cpphttp_tests COMMAND cpphttp_tests)

    add_executable(cpphttp_request_response_tests tests/request_response_tests.cpp)
    target_link_libraries(cpphttp_request_response_tests PRIVATE cpphttp)
    add_test(NAME cpphttp_request_response_tests COMMAND cpphttp_request_response_tests)

    add_executable(cpphttp_server_tests tests/server_integration_tests.cpp)
    target_link_libraries(cpphttp_server_tests PRIVATE cpphttp)
    add_test(NAME cpphttp_server_tests COMMAND cpphttp_server_tests)
endif()
