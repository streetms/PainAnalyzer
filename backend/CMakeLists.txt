cmake_minimum_required(VERSION 3.25)
set(CONAN_PROFILE ${CMAKE_SOURCE_DIR}/conan_profiles/linux-gcc15)
include(${CMAKE_SOURCE_DIR}/cmake/conan_bootstrap.cmake)

project(PainAnalyzerServer)


configure_file(
        ${CMAKE_SOURCE_DIR}/.env
        ${CMAKE_CURRENT_BINARY_DIR}/.env
        COPYONLY
)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Boost REQUIRED )
find_package(libpqxx REQUIRED)
find_package(jwt-cpp CONFIG REQUIRED)
find_package(nlohmann_json REQUIRED)
set(SRC
        src/main.cpp
        src/http/Server.cpp
        src/service/AuthService.cpp
        src/http/Session.cpp
        src/http/Router.cpp
        src/handlers/AuthHandlers.cpp
        src/database/repositories/AuthRepository.cpp
        src/database/ConnectionPool.cpp
        src/http/routes/RegisterRoutes.cpp
        src/utils/load_dotenv.cpp
)

add_executable(PainAnalyzerServer ${SRC})
target_link_libraries(PainAnalyzerServer
        libpqxx::pqxx
        nlohmann_json::nlohmann_json
        Boost::headers
        jwt-cpp::jwt-cpp
        stdc++_libbacktrace
        stdc++exp
)
target_include_directories(PainAnalyzerServer PRIVATE
        include
        ${CMAKE_SOURCE_DIR}/common/include
)