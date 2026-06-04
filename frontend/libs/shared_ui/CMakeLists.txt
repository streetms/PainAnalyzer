set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS
        Qml
        Quick
        QuickControls2
)

qt_add_qml_module(shared_ui
        URI Shared
        VERSION 1.0
        RESOURCE_PREFIX /qt/qml
        QML_FILES
        Snackbar.qml
)

target_link_libraries(shared_ui
        PUBLIC
        core
        Qt6::Quick
        Qt6::Qml
        Qt6::QuickControls2
)