include(FetchContent)

function(add_dependency name)
    set(options)
    set(oneValueArgs GIT_REPOSITORY GIT_TAG FIND_PACKAGE)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "" ${ARGN})

    if(ARG_FIND_PACKAGE)
        set(pkg ${ARG_FIND_PACKAGE})
    else()
        set(pkg ${name})
    endif()

    find_package(${pkg} QUIET)

    if(NOT ${pkg}_FOUND)
        message(STATUS "Fetching ${name} from Git")

        FetchContent_Declare(
                ${name}
                GIT_REPOSITORY ${ARG_GIT_REPOSITORY}
                GIT_TAG ${ARG_GIT_TAG}
                GIT_SHALLOW TRUE
        )

        FetchContent_MakeAvailable(${name})

        find_package(${pkg} QUIET)
    endif()
endfunction()

add_dependency(nlohmann_json
        GIT_REPOSITORY https://github.com/nlohmann/json.git
        GIT_TAG v3.12.0
        FIND_PACKAGE nlohmann_json
)

if (BUILD_BACKEND)
    add_dependency(
            cpp_dotenv
            https://github.com/adeharo9/cpp-dotenv.git
            GIT_TAG v1.0.0
    )
endif()
set(CMAKE_CXX_STANDARD 23)