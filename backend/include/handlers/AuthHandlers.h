#pragma once
#include "utils/alias.h"
#include "app/AppContext.h"
net::awaitable<Response> registerUser(Request req, AppContext& ctx);