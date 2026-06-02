from conan import ConanFile
from conan.tools.cmake import cmake_layout

class MyProjectConan(ConanFile):
    name = "PainAnalyzer"
    version = "1.0"

    settings = "os", "compiler", "build_type", "arch"

    requires = (
        "boost/1.90.0",
        "libpqxx/8.0.1",
        "nlohmann_json/3.12.0",
        "jwt-cpp/0.7.0",
    )

    generators = ("CMakeToolchain", "CMakeDeps")

    def configure(self):
        self.options["boost"].header_only = True