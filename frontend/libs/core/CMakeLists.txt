project(. LANGUAGES CXX)


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
add_library(core STATIC ${CORE_SOURCES} ${CORE_HEADERS})

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
)

# Подключаем include директорию
target_include_directories(core
        PUBLIC include
        ${CMAKE_SOURCE_DIR}/common/include
)
