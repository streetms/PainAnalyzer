set(CONAN_TOOLCHAIN "${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
set(CONAN_LOCK_FILE "${CMAKE_BINARY_DIR}/conan_install.lock")

if(NOT EXISTS "${CONAN_TOOLCHAIN}")

    file(LOCK "${CONAN_LOCK_FILE}" TIMEOUT 300)

    if(NOT EXISTS "${CONAN_TOOLCHAIN}")

        if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
            set(CMAKE_BUILD_TYPE Debug)
        endif()
        execute_process(
                COMMAND ${CONAN_CMD} install ${CMAKE_CURRENT_SOURCE_DIR}
                --output-folder=${CMAKE_BINARY_DIR}
                --profile:host=${CONAN_PROFILE}
                -s build_type=${CMAKE_BUILD_TYPE}
                --build=missing
                RESULT_VARIABLE conan_result
                OUTPUT_VARIABLE conan_stdout
                ERROR_VARIABLE conan_stderr
                COMMAND_ECHO STDOUT
        )

        if(NOT conan_result EQUAL 0)
            message(FATAL_ERROR "Conan install failed:\n${conan_stdout}\n${conan_stderr}")
        endif()

    endif()

endif()

include(${CONAN_TOOLCHAIN})

