//
// Created by konstantin on 15.04.2026.
//

#pragma once

#include "cpppg/ConnectionPool.h"
#include "cpppg/Database.h"
#include "infrastructure/database/repositories/IdentityRepository.h"
#include "infrastructure/database/repositories/TokenRepository.h"
#include "modules/auth/AuthHandlers.h"
#include "modules/pain/PainEpisodeHandlers.h"
#include "modules/pain/PainEpisodeRepository.h"
struct AppContext {
    AppContext( net::io_context& ioc,size_t connectionPoolSize, size_t threadPoolSize) :
    ioc_(ioc),
    threadPool_(threadPoolSize),
    connectionPool_("", connectionPoolSize, &AppContext::prepareStatements),
    db_(threadPool_,connectionPool_),
    authService_(db_),
    painEpisodeService_(db_),
    authHandler(authService_),
    painEpisodeHandler(painEpisodeService_){}
private:
    static void prepareStatements(pqxx::connection& connection) {
        IdentityRepository::prepare(&connection);
        TokenRepository::prepare(&connection);
        PainEpisodeRepository::prepare(&connection);
    }

    net::io_context& ioc_;
    db::Database db_;
    net::thread_pool threadPool_;
    db::ConnectionPool connectionPool_;

public:
    AuthService authService_;
    PainEpisodeService painEpisodeService_;
    AuthHandler authHandler;
    PainEpisodeHandlers painEpisodeHandler;
};
