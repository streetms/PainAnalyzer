//
// Created by konstantin on 09.05.2026.
//

#ifndef PAINAPP_REGISTERROUTES_H
#define PAINAPP_REGISTERROUTES_H
#include "app/AppContext.h"
#include "modules/auth/AuthHandlers.h"

#include <cpphttp/router.hpp>
namespace routes {
    void registerAuthRoutes(cpphttp::Router& router, AuthHandler& handler);
    void registerPainEpisodeRoutes(cpphttp::Router& router, PainEpisodeHandlers& handler);
}

#endif //PAINAPP_REGISTERROUTES_H

