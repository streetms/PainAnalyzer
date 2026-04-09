cmake_minimum_required(VERSION 3.21)
project(PainApp LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
find_package(Qt6 REQUIRED COMPONENTS
        Quick
        Quick3D
        Core
        Gui
        Qml
        QuickControls2
        Sql)

# Добавляем подпроекты
add_subdirectory(core)
add_subdirectory(patient)
