cmake_minimum_required(VERSION 3.25)
project(PainAnalyzerServer)

set(CMAKE_CXX_STANDARD 20)

# Независимая HTTP-библиотека. Пока старый HTTP-слой приложения остаётся
# на месте; подключаем библиотеку отдельной целью для поэтапной миграции.
add_subdirectory(cpp-http)

# Основная библиотека (вся бизнес-логика, DAL и т.д.)
add_subdirectory(src)
#
# Тесты
enable_testing()
add_subdirectory(tests)