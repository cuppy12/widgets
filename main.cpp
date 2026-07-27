#include "LoginBackend.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    LoginBackend loginBackend;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("LoginBackend", &loginBackend);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("widgets", "Main");

    return QGuiApplication::exec();
}
