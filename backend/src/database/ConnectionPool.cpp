#include "database/ConnectionPool.h"
#include "database/queries.hpp"
namespace db {
    ConnectionGuard::ConnectionGuard(ConnectionGuard &&other) noexcept
            : conn_(other.conn_), pool_(other.pool_) {
        other.conn_ = nullptr;
        other.pool_ = nullptr;
    }

    ConnectionGuard & ConnectionGuard::operator=(ConnectionGuard &&other) noexcept {
        if (this != &other) {
            release();

            conn_ = other.conn_;
            pool_ = other.pool_;

            other.conn_ = nullptr;
            other.pool_ = nullptr;
        }
        return *this;
    }

    ConnectionGuard::~ConnectionGuard() {
        release();
    }

    void ConnectionGuard::release() {
        if (conn_ && pool_) {
            pool_->release(conn_);
            conn_ = nullptr;
            pool_ = nullptr;
        }
    }

    ConnectionPool::ConnectionPool(std::string conninfo, size_t size) {
        for (size_t i = 0; i < size; ++i) {
            connections_.emplace_back(
                std::make_unique<pqxx::connection>(conninfo)
            );
            prepareStatements(connections_.back().get());
            idle_.push(connections_.back().get());
        }
    }

    ConnectionGuard ConnectionPool::acquire() {
        std::unique_lock lock(mutex_);

        cv_.wait(lock, [&] { return !idle_.empty(); });

        auto* conn = idle_.front();
        idle_.pop();

        return ConnectionGuard(conn, this);
    }

    void ConnectionPool::release(pqxx::connection *conn) {
        std::lock_guard lock(mutex_);
        idle_.push(conn);
        cv_.notify_one();
    }

    void ConnectionPool::prepareStatements(pqxx::connection *conn) {
        conn->prepare("create_auth_token",     sql::auth::create_auth_token);
        conn->prepare("create_user_identities", sql::auth::create_user_identities);
    }
}
