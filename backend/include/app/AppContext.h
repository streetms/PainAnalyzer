//
// Created by konstantin on 15.04.2026.
//

#pragma once
#include <memory>
#include "database/ConnectionPool.h"
#include "database/Database.h"
#include "database/repositories/AuthRepository.h"
#include "handlers/AuthHandlers.h"
#include "service/AuthService.h"

struct AppContext {
    AppContext(size_t connectionPoolSize, size_t threadPoolSize) :
    threadPool_(threadPoolSize),
    connectionPool_("",connectionPoolSize),
    db_(threadPool_,connectionPool_),
    authRepository_(db_),
    authService_(authRepository_),
    authHandler(authService_){
    }
    AuthHandler authHandler;
private:
    db::Database db_;
    net::thread_pool threadPool_;
    db::ConnectionPool connectionPool_;
    AuthRepository authRepository_;
    AuthService authService_;
};

