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
find_package(OpenSSL REQUIRED)

# Заголовки и исходники
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

# Создаём библиотеку
add_library(core SHARED ${CORE_SOURCES} ${CORE_HEADERS})


# Подключаем Qt
target_link_libraries(core
        PUBLIC
        Qt6::Quick
        Qt6::Quick3D
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::QuickControls2
        nlohmann_json::nlohmann_json
        OpenSSL::SSL
        OpenSSL::Crypto
)
set_target_properties(core PROPERTIES
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/patched_libs/${CMAKE_ANDROID_ARCH_ABI}"
)
message(-------
        ${CMAKE_BINARY_DIR}/patched_libs/${CMAKE_ANDROID_ARCH_ABI}
        --------)
if(ANDROID)
  get_target_property(PATIENT_LIBS core LINK_LIBRARIES)
  message(STATUS "CORE_LIBS = ${PATIENT_LIBS}")
  find_program(PATCHELF_EXECUTABLE patchelf)
  if(PATCHELF_EXECUTABLE)
    add_custom_target(patch_core_openssl ALL
      COMMAND ${PATCHELF_EXECUTABLE}
        --replace-needed libssl.so.3 libssl.so
        "${CMAKE_BINARY_DIR}/patched_libs/${CMAKE_ANDROID_ARCH_ABI}/$<TARGET_FILE_NAME:core>"
      COMMAND ${PATCHELF_EXECUTABLE}
        --replace-needed libcrypto.so.3 libcrypto.so
        "${CMAKE_BINARY_DIR}/patched_libs/${CMAKE_ANDROID_ARCH_ABI}/$<TARGET_FILE_NAME:core>"
      DEPENDS core
    )
  endif()
endif()



# Подключаем include директорию
target_include_directories(core
        PUBLIC include
        ${CMAKE_SOURCE_DIR}/common/include
)
