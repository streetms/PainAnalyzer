//
// Created by konstantin on 03.06.2026.
//

#ifndef PAINAPP_PAINEPISODEHANDLERS_H
#define PAINAPP_PAINEPISODEHANDLERS_H
#include <boost/asio.hpp>
#include "modules/pain/PainEpisodeService.h"
#include "utils/alias.h"

class PainEpisodeHandlers {
public:
    net::awaitable<Response> savePainEpisode(Request req);
    net::awaitable<Response> getPainEpisodes(Request req);
    PainEpisodeHandlers(PainEpisodeService& painEpisodeService);
private:
    PainEpisodeService& painEpisodeService;
};



#endif //PAINAPP_PAINEPISODEHANDLERS_H
