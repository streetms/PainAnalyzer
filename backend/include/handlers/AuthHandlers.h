#pragma once
#include "utils/alias.h"
#include "service/AuthService.h"
class AuthHandler {
public:
    net::awaitable<Response> registerUser(Request req);
    net::awaitable<Response> verifyUser(Request req);
    AuthHandler(AuthService& authService);
private:
    AuthService& auth_;
};

