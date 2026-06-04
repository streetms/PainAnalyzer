from conan import ConanFile
from conan.tools.cmake import cmake_layout

class MyProjectConan(ConanFile):
    name = "PainAnalyzer"
    version = "1.0"
    options = {
        "with_client": [True, False],
        "with_server": [True, False],
    }
    default_options = {
        "with_client": False,
        "with_server": False,
    }
    settings = "os", "compiler", "build_type", "arch"

    generators = ("CMakeToolchain", "CMakeDeps")
    def requirements(self):
        self.requires("nlohmann_json/3.12.0")
        if self.options.with_server:
            self.requires("boost/1.90.0")
            self.requires("libpqxx/8.0.1")
            self.requires("jwt-cpp/0.7.0")
        if self.options.with_client:
            self.requires("openssl/3.6.2")

    def configure(self):
        self.options["boost"].header_only = True