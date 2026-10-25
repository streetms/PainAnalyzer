cmake_minimum_required(VERSION 3.25)
project(PainAnalyzerServer)

set(CMAKE_CXX_STANDARD 20)

include(FetchContent)
FetchContent_Declare(
        cpp-http
        GIT_REPOSITORY https://github.com/streetms/cpp-http.git
        GIT_TAG main
)

FetchContent_MakeAvailable(cpp-http)

include(FetchContent)
FetchContent_Declare(
        cpp-pg
        GIT_REPOSITORY https://github.com/streetms/cpp-pg.git
        GIT_TAG main
)

FetchContent_MakeAvailable(cpp-pg)

# Основная библиотека (вся бизнес-логика, DAL и т.д.)
add_subdirectory(src)
#
# Тесты
enable_testing()
add_subdirectory(tests)
