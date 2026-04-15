//
// Created by konstantin on 15.04.2026.
//

#pragma once
#include <memory>
#include "service/AuthService.h"

struct AppContext {
    std::shared_ptr<AuthService> auth;
};

