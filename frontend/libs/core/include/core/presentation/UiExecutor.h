#pragma once
#include <QObject>
#include <functional>
#include <iostream>

class UiExecutor : public QObject
{
    Q_OBJECT
public:
    explicit UiExecutor(QObject* parent = nullptr){}

    template<typename Func>
    void run(Func&& func)
    {
        try {
            func();
        }
        catch (const std::exception& ex) {
            std::cerr << ex.what() << std::endl;
            emit errorOccurred(QString::fromStdString(ex.what()));
        }
        catch (...) {
            emit errorOccurred("Unknown error occurred");
        }
    }
    signals:
        void errorOccurred(const QString& message);
};
