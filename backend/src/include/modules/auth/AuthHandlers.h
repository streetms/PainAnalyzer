#pragma once
#include "utils/alias.h"
#include "AuthService.h"

class AuthHandler {
public:
    net::awaitable<Response> registerUser(Request req);
    net::awaitable<Response> verifyMagicLink(Request req);
    AuthHandler(AuthService& authService);
private:
    AuthService& auth_;
};

