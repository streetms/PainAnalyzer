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

find_package(OpenSSL REQUIRED)

set(SRC
        src/main.cpp
        src/presentation/PatientViewModel.cpp
)

set(HEADERS
        include/presentation/PatientViewModel.h
        src/infrastructure/PatientRepository.cpp
        include/infrastructure/PatientRepository.h
        src/application/PatientService.cpp
        include/application/PatientService.h
        src/presentation/SettingsViewModel.cpp
        include/presentation/SettingsViewModel.h
        src/application/SettingsService.cpp
        include/application/SettingsService.h
        src/presentation/PainEpisodeModel.cpp
        include/presentation/PainEpisodeModel.h
        src/presentation/PainEpisodeViewModel.cpp
        include/presentation/PainEpisodeViewModel.h
        src/application/PainEpisodeService.cpp
        include/application/PainEpisodeService.h
        src/infrastructure/PainEpisodeRepository.cpp
        include/infrastructure/PainEpisodeRepository.h
)

set(QT_ANDROID_DEPLOYMENT_TYPE Minimal)

qt_add_executable(patient
        ${SRC}
        ${HEADERS}
        resource.qrc
)

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
        qml/History/HistoryListView.qml
        qml/Record/TimeDialog.qml
)

if(ANDROID)

    set_target_properties(patient PROPERTIES
            QT_ANDROID_PACKAGE_SOURCE_DIR
            "${CMAKE_CURRENT_SOURCE_DIR}/android"
    )

    get_target_property(
            CORE_ANDROID_OPENSSL_DIR
            core
            PAINANALYZER_ANDROID_OPENSSL_DIR
    )

    if(NOT CORE_ANDROID_OPENSSL_DIR)
        message(FATAL_ERROR
                "Could not obtain Android OpenSSL staging directory from core"
        )
    endif()

    set(OPENSSL_ANDROID_SSL
            "${CORE_ANDROID_OPENSSL_DIR}/libssl.so"
    )

    set(OPENSSL_ANDROID_CRYPTO
            "${CORE_ANDROID_OPENSSL_DIR}/libcrypto.so"
    )

    message(STATUS
            "Patient Android OpenSSL directory: ${CORE_ANDROID_OPENSSL_DIR}"
    )

    message(STATUS
            "Patient Android OpenSSL SSL: ${OPENSSL_ANDROID_SSL}"
    )

    message(STATUS
            "Patient Android OpenSSL Crypto: ${OPENSSL_ANDROID_CRYPTO}"
    )

    if(NOT EXISTS "${OPENSSL_ANDROID_SSL}")
        message(FATAL_ERROR
                "Android OpenSSL SSL staging file does not exist:\n"
                "${OPENSSL_ANDROID_SSL}"
        )
    endif()

    if(NOT EXISTS "${OPENSSL_ANDROID_CRYPTO}")
        message(FATAL_ERROR
                "Android OpenSSL Crypto staging file does not exist:\n"
                "${OPENSSL_ANDROID_CRYPTO}"
        )
    endif()

    set_target_properties(patient PROPERTIES
            QT_ANDROID_EXTRA_LIBS
            "${OPENSSL_ANDROID_SSL};${OPENSSL_ANDROID_CRYPTO}"
    )

endif()

set_target_properties(patient PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY
        "${CMAKE_CURRENT_BINARY_DIR}/libs/${CMAKE_ANDROID_ARCH_ABI}"

        QT_QMLCACHEGEN TRUE
)

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

target_include_directories(patient
        PRIVATE
        include
)