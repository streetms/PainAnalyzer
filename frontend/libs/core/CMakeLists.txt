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
)

find_package(OpenSSL REQUIRED)

set(CORE_SOURCES
        src/infrastructure/network/ApiClient.cpp
        src/application/AuthService.cpp
)

set(CORE_HEADERS
        include/core/infrastructure/network/ApiClient.h
        include/core/application/AuthService.h
        src/infrastructure/AuthRepository.cpp
        include/core/infrastructure/AuthRepository.h
        src/presentation/AuthManager.cpp
        include/core/presentation/AuthManager.h
        include/core/presentation/UiExecutor.h
)

add_library(core SHARED
        ${CORE_SOURCES}
        ${CORE_HEADERS}
)

target_include_directories(core
        PUBLIC
        include
        ${CMAKE_SOURCE_DIR}/common/include
)

target_link_libraries(core
        PUBLIC
        Qt6::Quick
        Qt6::Quick3D
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::QuickControls2
        nlohmann_json::nlohmann_json
        PRIVATE
        OpenSSL::SSL
        OpenSSL::Crypto
)

if(ANDROID)

    find_program(PATCHELF_EXECUTABLE
            patchelf
            REQUIRED
    )

    set(OPENSSL_ANDROID_LIB_DIR
            "${openssl_PACKAGE_FOLDER_DEBUG}/lib"
    )

    set(OPENSSL_ANDROID_SSL_SOURCE
            "${OPENSSL_ANDROID_LIB_DIR}/libssl.so.3"
    )

    set(OPENSSL_ANDROID_CRYPTO_SOURCE
            "${OPENSSL_ANDROID_LIB_DIR}/libcrypto.so.3"
    )

    set(OPENSSL_ANDROID_STAGING
            "${CMAKE_CURRENT_BINARY_DIR}/android-openssl"
    )

    set(OPENSSL_ANDROID_SSL
            "${OPENSSL_ANDROID_STAGING}/libssl.so"
    )

    set(OPENSSL_ANDROID_CRYPTO
            "${OPENSSL_ANDROID_STAGING}/libcrypto.so"
    )

    message(STATUS
            "Android OpenSSL directory: ${OPENSSL_ANDROID_LIB_DIR}"
    )

    message(STATUS
            "Android OpenSSL SSL source: ${OPENSSL_ANDROID_SSL_SOURCE}"
    )

    message(STATUS
            "Android OpenSSL Crypto source: ${OPENSSL_ANDROID_CRYPTO_SOURCE}"
    )

    message(STATUS
            "Android OpenSSL staging: ${OPENSSL_ANDROID_STAGING}"
    )

    if(NOT EXISTS "${OPENSSL_ANDROID_SSL_SOURCE}")
        message(FATAL_ERROR
                "Android OpenSSL SSL library not found:\n"
                "${OPENSSL_ANDROID_SSL_SOURCE}"
        )
    endif()

    if(NOT EXISTS "${OPENSSL_ANDROID_CRYPTO_SOURCE}")
        message(FATAL_ERROR
                "Android OpenSSL Crypto library not found:\n"
                "${OPENSSL_ANDROID_CRYPTO_SOURCE}"
        )
    endif()

    # Create staging directory and copy OpenSSL.
    file(MAKE_DIRECTORY
            "${OPENSSL_ANDROID_STAGING}"
    )

    configure_file(
            "${OPENSSL_ANDROID_SSL_SOURCE}"
            "${OPENSSL_ANDROID_SSL}"
            COPYONLY
    )

    configure_file(
            "${OPENSSL_ANDROID_CRYPTO_SOURCE}"
            "${OPENSSL_ANDROID_CRYPTO}"
            COPYONLY
    )

    execute_process(
            COMMAND
            "${PATCHELF_EXECUTABLE}"
            --set-soname
            libssl.so
            "${OPENSSL_ANDROID_SSL}"
            RESULT_VARIABLE PATCHELF_SSL_RESULT
    )

    if(NOT PATCHELF_SSL_RESULT EQUAL 0)
        message(FATAL_ERROR
                "Failed to patch Android libssl.so"
        )
    endif()

    execute_process(
            COMMAND
            "${PATCHELF_EXECUTABLE}"
            --replace-needed
            libcrypto.so.3
            libcrypto.so
            "${OPENSSL_ANDROID_SSL}"
            RESULT_VARIABLE PATCHELF_SSL_CRYPTO_RESULT
    )

    if(NOT PATCHELF_SSL_CRYPTO_RESULT EQUAL 0)
        message(FATAL_ERROR
                "Failed to patch libssl.so dependency on libcrypto.so"
        )
    endif()

    if(NOT PATCHELF_SSL_RESULT EQUAL 0)
        message(FATAL_ERROR
                "Failed to patch Android libssl.so"
        )
    endif()

    execute_process(
            COMMAND
            "${PATCHELF_EXECUTABLE}"
            --set-soname
            libcrypto.so
            "${OPENSSL_ANDROID_CRYPTO}"

            RESULT_VARIABLE PATCHELF_CRYPTO_RESULT
    )

    if(NOT PATCHELF_CRYPTO_RESULT EQUAL 0)
        message(FATAL_ERROR
                "Failed to patch Android libcrypto.so"
        )
    endif()


    set_property(
            TARGET core
            PROPERTY PAINANALYZER_ANDROID_OPENSSL_DIR
            "${OPENSSL_ANDROID_STAGING}"
    )
    add_custom_command(
            TARGET core
            POST_BUILD

            COMMAND
            "${PATCHELF_EXECUTABLE}"
            --replace-needed
            libssl.so.3
            libssl.so
            "$<TARGET_FILE:core>"

            COMMAND
            "${PATCHELF_EXECUTABLE}"
            --replace-needed
            libcrypto.so.3
            libcrypto.so
            "$<TARGET_FILE:core>"

            COMMENT
            "Fixing Android libcore OpenSSL dependencies"
    )
endif()

if(ANDROID)
    set_target_properties(core PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY
            "${CMAKE_BINARY_DIR}/patched_libs/${CMAKE_ANDROID_ARCH_ABI}"
    )
endif()