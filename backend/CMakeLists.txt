cmake_minimum_required(VERSION 3.21)
project(PainAnalyzerServer LANGUAGES CXX)
find_package(Boost REQUIRED COMPONENTS system)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SRC
        src/main.cpp
)
set(HEADERS

)

add_executable(PainAnalyzerServer ${SRC} ${HEADERS})
target_link_libraries(PainAnalyzerServer
        Boost::system
        pthread
)