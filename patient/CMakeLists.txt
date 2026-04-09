cmake_minimum_required(VERSION 3.21)
project(patient_app LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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
set(SRC
        src/main.cpp
        src/patient.cpp
        src/PatientManager.cpp
)

set(HEADERS
        src/patient.h
        src/PatientManager.h
)

set(QML_FILES
        qml/App.qml
        qml/AutorizationForms/FIO.qml
        qml/AutorizationForms/Phone.qml
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
)

# Создаём Qt-приложение
qt_add_executable(patient_app ${SRC} ${HEADERS} ${QML_FILES})

# Подключаем core как библиотеку
target_link_libraries(patient_app
        PRIVATE core
        PRIVATE
        Qt6::Quick
        Qt6::Quick3D
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::QuickControls2
        Qt6::Sql
)

# Настраиваем пути поиска и ресурс QML
qt_add_resources(patient_app "qml_files"
        PREFIX "/patient"                # важно: должен совпадать с qrc:/patient
        BASE "${CMAKE_CURRENT_SOURCE_DIR}/qml"
        FILES ${QML_FILES}
        resource.qrc
)

#Если используешь CMake < 3.21 — можно вручную прописать ресурсы
#set_target_properties(patient_app PROPERTIES AUTOMOC ON)#