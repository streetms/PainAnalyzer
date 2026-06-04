cmake_minimum_required(VERSION 3.25)
configure_file(
        ${CMAKE_SOURCE_DIR}/.env
        ${CMAKE_CURRENT_BINARY_DIR}/.env
        COPYONLY
)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Boost REQUIRED)
find_package(libpqxx REQUIRED)
find_package(nlohmann_json REQUIRED)
find_package(jwt-cpp CONFIG REQUIRED)
set(SRC
        src/main.cpp
        src/infrastructure/http/Server.cpp
        src/modules/auth/AuthService.cpp
        src/infrastructure/http/Session.cpp
        src/infrastructure/http/Router.cpp
        src/modules/auth/AuthHandlers.cpp
        include/infrastructure/http/Server.h
        include/infrastructure/database/Database.h
        include/modules/auth/AuthService.h
        include/infrastructure/http/Session.h
        include/infrastructure/http/Router.h
        include/modules/auth/AuthHandlers.h
        include/infrastructure/database/ConnectionPool.h
        src/infrastructure/database/ConnectionPool.cpp
        include/infrastructure/http/routes/RegisterRoutes.h
        src/infrastructure/http/routes/RegisterRoutes.cpp
        src/utils/load_dotenv.cpp
        include/infrastructure/database/repositories/IdentityRepository.h
        src/infrastructure/database/repositories/IdentityRepository.cpp
        include/infrastructure/database/repositories/TokenRepository.h
        src/infrastructure/database/repositories/TokenRepository.cpp
        ../common/include/models/PainEpisode.h
        src/modules/pain/PainEpisodeHandlers.cpp
        include/modules/pain/PainEpisodeHandlers.h
        src/modules/pain/PainEpisodeService.cpp
        include/modules/pain/PainEpisodeService.h
)

add_executable(PainAnalyzerServer ${SRC})
target_link_libraries(PainAnalyzerServer
        Boost::headers
        libpqxx::pqxx
        nlohmann_json::nlohmann_json
        jwt-cpp::jwt-cpp
        stdc++_libbacktrace
        stdc++exp
)
target_include_directories(PainAnalyzerServer PRIVATE
        include
        ${CMAKE_SOURCE_DIR}/common/include
)