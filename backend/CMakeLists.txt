cmake_minimum_required(VERSION 3.25)
project(PainAnalyzerServer)

set(CMAKE_CXX_STANDARD 20)

# Основная библиотека (вся бизнес-логика, DAL и т.д.)
add_subdirectory(src)
#
# Тесты
enable_testing()
add_subdirectory(tests)