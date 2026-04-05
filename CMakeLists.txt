cmake_minimum_required(VERSION 3.29)
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
        src/record.cpp
        src/record.h
)


# 📦 куда класть .so, чтобы androiddeployqt нашёл его
set_target_properties(PainAnalyzer PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/android-build/libs/${ANDROID_ABI}
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/android-build/libs/${ANDROID_ABI}
)

qt_add_resources(PainAnalyzer "app_resources"
        FILES
        resource.qrc
)


target_link_libraries(PainAnalyzer PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::Quick3D
        Qt6::QuickControls2
)
