project(PainAnalyzerServer)
configure_file(
        ${CMAKE_SOURCE_DIR}/.env
        ${CMAKE_CURRENT_BINARY_DIR}/.env
        COPYONLY
)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Boost REQUIRED)
find_package(libpqxx REQUIRED)

set(SRC
        src/main.cpp
        src/http/Server.cpp
        src/database/DataBase.cpp
        src/service/AuthService.cpp
        src/http/Session.cpp
        src/http/Router.cpp
        src/handlers/AuthHandlers.cpp
)

add_executable(PainAnalyzerServer ${SRC})
target_link_libraries(PainAnalyzerServer
        PRIVATE common
        Boost::headers
        libpqxx::pqxx
        cpp_dotenv
)
target_include_directories(PainAnalyzerServer PRIVATE include)