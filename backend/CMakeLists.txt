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
        src/Server.cpp
        src/database/DataBase.cpp
        src/database/auth.cpp
)
set(HEADERS
        src/Server.h
        src/database/DataBase.h
        src/database/auth.h
)


add_executable(PainAnalyzerServer ${SRC} ${HEADERS})
target_link_libraries(PainAnalyzerServer
        PRIVATE common
        Boost::headers
        libpqxx::pqxx
        cpp_dotenv
)