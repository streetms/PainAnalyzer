project(patient)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
set(CMAKE_ANDROID_ARCH_ABI arm64-v8a)


set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)
find_package(Qt6 REQUIRED COMPONENTS
        Quick
        QuickControls2
        Quick3D
        Network
        Qml
)

set(SRC
        src/main.cpp
        src/presentation/PatientManager.cpp
)

set(HEADERS
        include/presentation/PatientManager.h
        src/infrastructure/PatientRepository.cpp
        include/infrastructure/PatientRepository.h
        src/application/PatientService.cpp
        include/application/PatientService.h
)
set(QT_ANDROID_DEPLOYMENT_TYPE Minimal)
## Создаём Qt-приложение
qt_add_executable(patient ${SRC} ${HEADERS}  resource.qrc)
qt_add_qml_module(patient
        URI Patient
        VERSION 1.0
        RESOURCE_PREFIX /qt/qml
        QML_FILES
        qml/core/App.qml
        qml/AutorizationForms/FIO.qml
        qml/AutorizationForms/Email.qml
        qml/AutorizationForms/BaseInfo.qml
        qml/Record/Record.qml
        qml/Record/HeadScreen.qml
        qml/3D/HeadModel.qml
        qml/3D/Scene3D.qml
        qml/Record/SelectableListPage.qml
        qml/Record/SymptomsScreen.qml
        qml/Record/TriggerScreen.qml
        qml/Record/PainTypeScreen.qml
        qml/Record/DrugScreen.qml
        qml/Record/AurasScreen.qml
        qml/History/History.qml
        qml/Record/Chip.qml
        qml/Menu/MainMenu.qml
        qml/Menu/CardButton.qml
        qml/History/PainLevelGraph.qml
)
set_target_properties(patient PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
)
set_target_properties(patient PROPERTIES
        QT_QMLCACHEGEN TRUE
)

# Подключаем core как библиотеку
target_link_libraries(patient
        PRIVATE
        core
        shared_ui
        Qt6::Quick
        Qt6::Quick3D
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::QuickControls2
        Qt6::Network
        nlohmann_json::nlohmann_json
)
if(ANDROID)
    set_property(TARGET patient APPEND PROPERTY
            QT_ANDROID_EXTRA_LIBS
            "/home/konstantin/.conan2/p/b/opens2e5dd1f490a3c/p/lib/libssl.so"
            "/home/konstantin/.conan2/p/b/opens2e5dd1f490a3c/p/lib/libcrypto.so"
    )
endif()
target_include_directories(patient PRIVATE
        include
)