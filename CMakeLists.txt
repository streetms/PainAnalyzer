cmake_minimum_required(VERSION 3.21.1)

option(LINK_INSIGHT "Link Qt Insight Tracker library" ON)
option(BUILD_QDS_COMPONENTS "Build design studio components" OFF)

project(PainAnalyzerApp LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

set(QML_FILES
        PainAnalyzerContent/App.qml
        PainAnalyzerContent/Screen01.ui.qml
        PainAnalyzerContent/Screen02.ui.qml)

qt_add_executable(PainAnalyzerApp src/main.cpp)
qt_add_qml_module(PainAnalyzerApp
        URI PainAnalyzer
        VERSION 1.0
        QML_FILES ${QML_FILES}

)

target_link_libraries(PainAnalyzerApp PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::QuickControls2
)

set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)
set(QML_IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY}
        CACHE STRING "Import paths for Qt Creator's code model"
        FORCE
)


include(GNUInstallDirs)
install(TARGETS PainAnalyzerApp
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# make IDEs aware of the QML import path
set(QML_IMPORT_PATH ${PROJECT_BINARY_DIR}/qml CACHE PATH
        "Path to the custom QML components defined by the project")
