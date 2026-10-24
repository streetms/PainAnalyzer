cmake_minimum_required(VERSION 3.25)
configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/.env
        ${CMAKE_CURRENT_BINARY_DIR}/.env
        COPYONLY
)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Boost REQUIRED COMPONENTS url)
find_package(nlohmann_json REQUIRED)
find_package(jwt-cpp CONFIG REQUIRED)
set(SRC
        src/modules/auth/AuthService.cpp
        src/modules/auth/AuthHandlers.cpp
        src/infrastructure/database/repositories/IdentityRepository.cpp
        src/infrastructure/database/repositories/TokenRepository.cpp
        include/modules/auth/AuthService.h
        include/modules/auth/AuthHandlers.h
        include/infrastructure/http/routes/RegisterRoutes.h
        src/infrastructure/http/routes/RegisterRoutes.cpp
        src/utils/load_dotenv.cpp
        ../../common/include/models/PainEpisode.h
        src/modules/pain/PainEpisodeHandlers.cpp
        include/modules/pain/PainEpisodeHandlers.h
        src/modules/pain/PainEpisodeService.cpp
        src/modules/pain/PainEpisodeRepository.cpp
        include/modules/pain/PainEpisodeService.h
        include/modules/pain/PainEpisodeRepository.h
        include/infrastructure/database/repositories/IdentityRepository.h
        include/infrastructure/database/repositories/TokenRepository.h
)

add_library(server_core
        ${SRC}
)

target_link_libraries(server_core cpppg cpphttp::cpphttp)
target_link_libraries(server_core
        Boost::url
        nlohmann_json::nlohmann_json
        jwt-cpp::jwt-cpp
        stdc++exp
)
add_executable(PainAnalyzerServer src/main.cpp
)
target_link_libraries(PainAnalyzerServer server_core)
target_include_directories(server_core PUBLIC
        include
        ${CMAKE_SOURCE_DIR}/common/include
)
