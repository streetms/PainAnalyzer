#include <fstream>
#include <string>
#include "utils/load_dotenv.h"
void load_dotenv() {
    std::ifstream file(".env");
    std::string line;

    while (std::getline(file, line)) {
        auto pos = line.find('=');
        if (pos != std::string::npos) {
            auto key = line.substr(0, pos);
            auto value = line.substr(pos + 1);
            setenv(key.c_str(), value.c_str(), 1);
        }
    }
}
