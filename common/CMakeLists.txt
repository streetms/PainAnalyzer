project(common LANGUAGES CXX)

set(CORE_HEADERS
        include/models/Patient.h
        include/models/User.h
)

# Создаём библиотеку
add_library(common INTERFACE ${CORE_HEADERS})

# Подключаем Qt
target_link_libraries(common
        INTERFACE
        nlohmann_json::nlohmann_json
)

# Подключаем include директорию
target_include_directories(common
        INTERFACE include
)
