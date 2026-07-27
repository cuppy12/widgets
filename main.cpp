#include "LoginBackend.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setOrganizationName("MTHK");
    QGuiApplication::setApplicationName("widgets");

    QQmlApplicationEngine engine;
    auto *loginBackend = new LoginBackend(&engine);
    QQmlEngine::setObjectOwnership(loginBackend, QQmlEngine::CppOwnership);
    engine.rootContext()->setContextProperty("LoginBackend", loginBackend);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    QObject::connect(&app, &QCoreApplication::aboutToQuit, &engine, [&engine]() {
        engine.rootContext()->setContextProperty("LoginBackend", QVariant());
    });
    engine.loadFromModule("widgets", "Main");

    return QGuiApplication::exec();
}
