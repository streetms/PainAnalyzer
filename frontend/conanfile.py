from conan import ConanFile
from conan.tools.cmake import cmake_layout

class MyProjectConan(ConanFile):
    name = "PainAnalyzer"
    version = "1.0"

    settings = "os", "compiler", "build_type", "arch"

    requires = (
        "nlohmann_json/3.12.0"
    )

    generators = ("CMakeToolchain", "CMakeDeps")
