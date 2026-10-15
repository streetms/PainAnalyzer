#include "infrastructure/http/routes/RegisterRoutes.h"
#include "infrastructure/http/BeastAdapter.h"


namespace routes {
    void registerAuthRoutes(cpphttp::Router& router, AuthHandler& handler) {
        router.add("/register", http_adapter::adapt([&](Request req) {
            return handler.registerUser(std::move(req));
        }));
        router.add("/auth/verify", http_adapter::adapt([&](Request req) {
            return handler.verifyMagicLink(std::move(req));
        }));
    }


    void registerPainEpisodeRoutes(cpphttp::Router& router, PainEpisodeHandlers& handler) {
        router.add("/savePainEpisode", http_adapter::adapt([&](Request req) {
            return handler.savePainEpisode(std::move(req));
        }));
        router.add("/episodes", http_adapter::adapt([&](Request req) {
            return handler.getPainEpisodes(std::move(req));
        }));
    }
}
