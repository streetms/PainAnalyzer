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
        src/service/AuthService.cpp
        src/http/Session.cpp
        src/http/Router.cpp
        src/handlers/AuthHandlers.cpp
        include/http/Server.h
        include/database/Database.h
        include/service/AuthService.h
        include/http/Session.h
        include/http/Router.h
        include/handlers/AuthHandlers.h
        include/database/queries/auth/create_auth_token.h
        include/database/queries/auth/create_user_identities.h
        src/database/repositories/AuthRepository.cpp
        include/database/repositories/AuthRepository.h
        include/database/queries.hpp
        include/database/ConnectionPool.h
        src/database/ConnectionPool.cpp
        include/http/routes/RegisterRoutes.h
        src/http/routes/RegisterRoutes.cpp
)

add_executable(PainAnalyzerServer ${SRC})
target_link_libraries(PainAnalyzerServer
        PRIVATE common
        Boost::headers
        libpqxx::pqxx
        cpp_dotenv
)
target_include_directories(PainAnalyzerServer PRIVATE include)