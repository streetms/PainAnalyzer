//
// Created by konstantin on 18.06.2026.
//

#include "infrastructure/PainEpisodeRepository.h"
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>
#include <QNetworkReply>
#include <qpointer.h>
#include <exception>
#include <nlohmann/json.hpp>
#include <vector>

void PainEpisodeRepository::fetchEpisodesFromNetwork(std::string_view from, std::string_view to) {
    // 1. Формируем параметры в виде JSON-объекта
    nlohmann::json params;

    // Переводим QDate в строку "yyyy-MM-dd", а затем в std::string
    params["start"] = from;
    params["end"]   = to;

    // Базовый эндпоинт, БЕЗ параметров (они добавятся внутри ApiClient::get)
    QString endpoint = "/episodes";

    // Создаем безопасный указатель
    QPointer<PainEpisodeRepository> safeThis(this);

    // 2. Вызываем get, передавая endpoint, JSON-параметры и callback
    api.get(endpoint, params, [safeThis](QNetworkReply* reply) {
        if (!safeThis) return;
        // Проверяем сетевые ошибки
        if (reply->error() != QNetworkReply::NoError) {
            // emit safeThis->errorOccurred(reply->errorString());
            return;
        }

        QByteArray responseData = reply->readAll();
        std::vector<PainEpisode> episodesList;
        qDebug() << responseData.toStdString() << "--------------------";
        // 3. Парсим ответ
        try {
            auto jsonResponse = nlohmann::json::parse(responseData.toStdString());

            if (jsonResponse.is_array()) {
                for (const auto& item : jsonResponse) {
                    PainEpisode episode = nlohmann::json::parse(item.dump()).get<PainEpisode>();;

                    episodesList.push_back(std::move(episode));
                }
            } else {
                //emit safeThis->errorOccurred("Ошибка: Сервер вернул не массив");
                return;
            }

        } catch (const nlohmann::json::parse_error& e) {
            qDebug() << e.what();
            //emit safeThis->errorOccurred(QString("Ошибка парсинга JSON: %1").arg(e.what()));
            return;
        } catch (const std::exception& e) {
            qDebug() << e.what();
           // emit safeThis->errorOccurred(QString("Ошибка обработки данных: %1").arg(e.what()));
            return;
        }

        // 4. Отдаем готовые данные
        emit safeThis->episodesFetched(episodesList);
    });
}

