//
// Created by konstantin on 15.04.2026.
//

#pragma once
#include <memory>
#include "infrastructure/database/ConnectionPool.h"
#include "infrastructure/database/Database.h"
#include "modules/auth/AuthHandlers.h"
#include "modules/auth/AuthService.h"
struct AppContext {
    AppContext( net::io_context& ioc,size_t connectionPoolSize, size_t threadPoolSize) :
    ioc_(ioc),
    threadPool_(threadPoolSize),
    connectionPool_("",connectionPoolSize),
    db_(threadPool_,connectionPool_),
    authService_(db_),
    authHandler(authService_){
    }

private:
    net::io_context& ioc_;
    db::Database db_;
    net::thread_pool threadPool_;
    db::ConnectionPool connectionPool_;
    AuthService authService_;
public:
    AuthHandler authHandler;
};

