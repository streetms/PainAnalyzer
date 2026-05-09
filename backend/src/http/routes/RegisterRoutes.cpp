//
// Created by konstantin on 09.05.2026.
//
#include "http/routes/RegisterRoutes.h"
namespace routes {
    void registerAuthRoutes(Router& router, AuthHandler& handler){
        router.add("/register",[&](Request req) {
            return handler.registerUser(req);
        });
    }
}