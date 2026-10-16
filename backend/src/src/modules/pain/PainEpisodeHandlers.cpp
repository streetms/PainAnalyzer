//
// Created by konstantin on 03.06.2026.
//

#include "modules/pain/PainEpisodeHandlers.h"

#include <iostream>


net::awaitable<Response> PainEpisodeHandlers::savePainEpisode(Request req) {
    http::response<http::string_body> res{
        http::status::ok,
        req.version()
    };
    auto json = nlohmann::json::parse(req.body());
    co_await painEpisodeService.insertPainEpisode(json);
    co_return res;
}

net::awaitable<Response> PainEpisodeHandlers::getPainEpisodes(Request req) {
    http::response<http::string_body> res{
        http::status::ok,
        req.version()
    };
    boost::system::result<urls::url_view> url_res = urls::parse_origin_form(req.target());

    urls::url_view url = url_res.value();
    auto params = url.params();
    auto it_start = params.find("start");
    auto it_end = params.find("end");
    if (it_start != params.end() && it_end != params.end()) {
        std::string startStr = (*it_start)->value;
        std::string endStr = (*it_end).value;
        ulid patient_id = "01KT97H6RJ74K2CNFHP7NPS1TA";
        std::vector<PainEpisode> episodes = co_await painEpisodeService.getPainEpisodes(patient_id,startStr,endStr);
        nlohmann::json j = episodes;

        // 4. Кладем JSON-строку в тело ответа
        res.body() = j.dump();
        std::cout << res.body();// можно j.dump(4), если хотите красивое форматирование с отступами
        res.set(http::field::content_type, "application/json");
        res.prepare_payload();
    }
    co_return res;
}

PainEpisodeHandlers::PainEpisodeHandlers(PainEpisodeService &painEpisodeService) :     painEpisodeService(painEpisodeService) {

}
