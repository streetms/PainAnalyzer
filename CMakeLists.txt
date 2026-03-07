cmake_minimum_required(VERSION 3.16)
project(PainAnalyzer LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS
        Quick
        Quick3D
        Core
        Gui
        Qml
        QuickControls2)

qt_add_executable(PainAnalyzer
        src/main.cpp
)

# ✅ Подключаем ресурсы правильно
qt_add_resources(PainAnalyzer "app_resources"
        FILES
        resource.qrc
)

# ✅ Линкуем нужные модули
target_link_libraries(PainAnalyzer PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::Quick3D
        Qt6::QuickControls2
)
