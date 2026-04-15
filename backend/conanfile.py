from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMakeDeps, cmake_layout

class MyProjectConan(ConanFile):
    name = "PainAnalyzer"
    version = "1.0"

    settings = "os", "compiler", "build_type", "arch"

    requires = (
        "boost/1.90.0",
        "libpqxx/8.0.1",
    )

    generators = ("CMakeToolchain", "CMakeDeps")

    def layout(self):
        cmake_layout(self)
    def configure(self):
        self.options["boost"].header_only = True