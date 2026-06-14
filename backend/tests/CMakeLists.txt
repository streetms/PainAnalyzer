set(CMAKE_CXX_STANDARD 23)

configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/.env
        ${CMAKE_CURRENT_BINARY_DIR}/.env
        COPYONLY
)
configure_file(
        ${CMAKE_SOURCE_DIR}/backend/schema.sql
        ${CMAKE_CURRENT_BINARY_DIR}/schema.sql
        COPYONLY
)
find_package(GTest REQUIRED)
add_executable(run_tests
        src/main.cpp
)

target_link_libraries(run_tests
        server_core
        GTest::gtest
)


add_test(NAME run_tests COMMAND run_tests)