set(CONAN_TOOLCHAIN "${CMAKE_BINARY_DIR}/conan_toolchain.cmake")
set(CONAN_LOCK_FILE "${CMAKE_BINARY_DIR}/conan_install.lock")

execute_process(
        COMMAND ${CONAN_CMD} install ${CMAKE_CURRENT_SOURCE_DIR}
        --output-folder=${CMAKE_BINARY_DIR}
        --profile:host=${CONAN_PROFILE}
        -s build_type=${CMAKE_BUILD_TYPE}
        --build=missing
        RESULT_VARIABLE conan_result
)

if(NOT conan_result EQUAL 0)
    message(FATAL_ERROR "Conan install failed")
endif()

include(${CMAKE_BINARY_DIR}/conan_toolchain.cmake)

include(${CONAN_TOOLCHAIN})

