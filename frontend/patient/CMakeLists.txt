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
        src/PatientManager.cpp
)

set(HEADERS
        src/PatientManager.h
)
set(QT_ANDROID_DEPLOYMENT_TYPE Minimal)
## Создаём Qt-приложение
qt_add_executable(patient ${SRC} ${HEADERS}  resource.qrc)
qt_add_qml_module(patient
        URI Patient
        VERSION 1.0
        RESOURCE_PREFIX /qt/qml
        QML_FILES
        qml/App.qml
        qml/AutorizationForms/FIO.qml
        qml/AutorizationForms/Email.qml
        qml/AutorizationForms/BaseInfo.qml
        qml/Screen01.qml
        qml/HeadScreen.qml
        qml/HeadModel.qml
        qml/Scene3D.qml
        qml/SelectionDialog.qml
        qml/SymptomsScreen.qml
        qml/TriggerScreen.qml
        qml/PainTypeScreen.qml
        qml/DrugScreen.qml
        qml/AurasScreen.qml
        qml/Menu.qml
        qml/History.qml
)
set_target_properties(patient PROPERTIES
        QT_QMLCACHEGEN TRUE
)

# Подключаем core как библиотеку
target_link_libraries(patient
        PRIVATE core common
        PRIVATE
        Qt6::Quick
        Qt6::Quick3D
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::QuickControls2
        Qt6::Network
)



#Если используешь CMake < 3.21 — можно вручную прописать ресурсы
#set_target_properties(patient PROPERTIES AUTOMOC ON)#