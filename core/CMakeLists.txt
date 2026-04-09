project(core LANGUAGES CXX)

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

# Заголовки и исходники
set(CORE_SOURCES
        src/auth/AuthService.cpp
        src/user/UserManager.cpp
        src/user/UserService.cpp
)

set(CORE_HEADERS
        include/auth/AuthService.h
        include/user/UserManager.h
        include/user/UserService.h
        include/models/User.h
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
        Qt6::Sql
)

# Подключаем include директорию
target_include_directories(core
        PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include
)
