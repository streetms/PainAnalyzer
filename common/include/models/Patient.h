//
// Created by konstantin on 06.04.2026.
//
#pragma once

#include <optional>
#include <string>
#include <nlohmann/json.hpp>


struct Patient {
    std::string email;
    std::string fullName;
    std::string birthday;
    int height;
    int weight;
};
NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(Patient,email, fullName, birthday, height, weight)