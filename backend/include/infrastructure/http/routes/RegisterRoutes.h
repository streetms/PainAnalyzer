//
// Created by konstantin on 09.05.2026.
//

#ifndef PAINAPP_REGISTERROUTES_H
#define PAINAPP_REGISTERROUTES_H
#include "app/AppContext.h"
#include "modules/auth/AuthHandlers.h"

#include "infrastructure/http/Router.h"
namespace routes {
    void registerAuthRoutes(Router& router, AuthHandler& handler);
}

#endif //PAINAPP_REGISTERROUTES_H

